// مسؤول عن اتصال WebSocket بخدمة Reverb وإدارة اشتراكات تتبع مواقع الفنيين
// وقنوات الإشعارات الخاصة (private channels).
import 'dart:async';
import 'dart:convert';
import 'package:car_care/core/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef LocationCallback = void Function(double lat, double lng);
typedef RawEventCallback = void Function(Map<String, dynamic> data);

/// Requests a Laravel broadcasting-auth signature for a private channel.
/// Must use the app's existing authenticated HTTP client (ApiService) —
/// PusherService itself never talks HTTP directly.
typedef BroadcastAuthProvider =
    Future<String?> Function({
      required String socketId,
      required String channelName,
    });

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // Public SOS tracking channels — unchanged shape/behavior from Phase 1.
  final Map<String, LocationCallback> _callbacks = {};

  // Private channels: one raw-payload callback per "channel|event" pair,
  // plus one auth provider per channel (re-invoked on every reconnect).
  final Map<String, RawEventCallback> _privateEventCallbacks = {};
  final Map<String, BroadcastAuthProvider> _privateAuthProviders = {};

  final Set<String> _subscribedChannels = {}; // ← منع الاشتراك المزدوج
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _connected = false;
  bool _intentionalDisconnect = false;

  /// Set fresh on every `pusher:connection_established` — a private
  /// channel's auth signature is only valid for the socket_id it was
  /// signed against, so a reconnect always invalidates it.
  String? _socketId;

  // ─── Test-only observation hooks ───────────────────────────────────────
  // Additive and inert by default (null/no-op in production) — they let
  // tests observe outgoing frames and feed synthetic incoming messages
  // without a real socket, instead of reaching into private state.
  @visibleForTesting
  void Function(Map<String, dynamic> data)? debugOnSend;

  @visibleForTesting
  void debugHandleMessage(String rawMessage) => _onMessage(rawMessage);

  @visibleForTesting
  bool debugIsSubscribed(String channelName) =>
      _subscribedChannels.contains(channelName);

  @visibleForTesting
  String? get debugSocketId => _socketId;

  /// Overrides how [init] obtains its [WebSocketChannel] — null (default)
  /// uses the real `WebSocketChannel.connect`. Tests substitute a fake
  /// channel so nothing ever touches a real socket.
  @visibleForTesting
  WebSocketChannel Function(Uri uri)? debugChannelFactory;

  // ─── Connect ──────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_channel != null) return;

    _intentionalDisconnect = false;
    _reconnectTimer?.cancel();

    // Reverb speaks plain WebSocket over an http host and TLS WebSocket
    // (wss) over an https one — matching REVERB_SCHEME keeps prod (https,
    // port 443) and local dev (http, no TLS) both working.
    final wsScheme = Env.reverbScheme == 'https' ? 'wss' : 'ws';
    final wsUrl =
        '$wsScheme://${Env.reverbHost}:${Env.reverbPort}/app/${Env.reverbKey}'
        '?protocol=7&client=flutter&version=1.0&flash=false';

    if (kDebugMode) debugPrint('🔌 Connecting to: $wsUrl');

    final uri = Uri.parse(wsUrl);
    _channel = (debugChannelFactory ?? WebSocketChannel.connect)(uri);

    // `ready` completes with an error if the handshake fails (e.g. rejected
    // upgrade); nothing else awaits it, so leaving it unhandled crashes the
    // app. The stream's onError/onDone below already drive the reconnect —
    // this only silences the otherwise-unhandled Future rejection.
    unawaited(
      _channel!.ready.catchError((Object e) {
        if (kDebugMode) debugPrint('❌ WS connect failed: $e');
      }),
    );

    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: (e) {
        if (kDebugMode) debugPrint(' WS Error: $e');
      },
      onDone: () {
        if (kDebugMode) debugPrint('🔌 WS Disconnected');
        _channel = null;
        _connected = false;
        _socketId = null;
        _subscribedChannels.clear();
        // Only accidental drops reconnect — an intentional (logout) shutdown
        // must stay disconnected until something explicitly calls init() again.
        if (_intentionalDisconnect) return;
        _reconnectTimer = Timer(const Duration(seconds: 3), init);
      },
    );

    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _send({'event': 'pusher:ping', 'data': {}});
    });
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String) as Map<String, dynamic>;
      final event = decoded['event'] as String?;
      final channel = decoded['channel'] as String?;

      if (kDebugMode) debugPrint('📨 Event: $event | Channel: $channel');

      // ─── لما يتصل، اشترك على كل الـ channels المنتظرة ─────────────────
      if (event == 'pusher:connection_established') {
        _connected = true;
        _socketId = _extractSocketId(decoded['data']);
        if (kDebugMode) debugPrint('✅ Pusher connected! socket_id=$_socketId');

        for (final ch in _callbacks.keys) {
          if (!_subscribedChannels.contains(ch)) {
            _subscribeChannel(ch);
          }
        }

        // Private channels always re-authenticate against the new
        // socket_id before resubscribing — a stale auth signature from a
        // previous connection is never reused.
        for (final channelName in _privateAuthProviders.keys.toList()) {
          unawaited(_authenticateAndSubscribePrivate(channelName));
        }
        return;
      }

      if (event == 'pusher:subscription_error' ||
          event == 'pusher:error') {
        // Never expose auth/token content — just note which channel failed.
        if (kDebugMode) {
          debugPrint(' Pusher $event on channel: ${channel ?? 'unknown'}');
        }
        return;
      }

      // Diagnostic-only: confirms a private channel's `pusher:subscribe`
      // frame was actually accepted by Reverb. Nothing subscribes to this
      // event via _privateEventCallbacks, so without this branch a
      // successful private subscription is otherwise invisible in logs.
      if (event == 'pusher_internal:subscription_succeeded') {
        if (kDebugMode) {
          debugPrint('✅ subscription_succeeded: ${channel ?? 'unknown'}');
        }
        return;
      }

      // ─── تحديث موقع الفني (SOS) — سلوك غير معدَّل ──────────────────────
      if (event == 'location.updated' && channel != null) {
        final callback = _callbacks[channel];
        if (callback == null) return;

        final dataMap = _decodeEventData(decoded['data']);
        if (dataMap == null) return;

        final lat = double.tryParse(dataMap['lat'].toString());
        final lng = double.tryParse(dataMap['lng'].toString());

        if (lat != null && lng != null) {
          if (kDebugMode) debugPrint('📍 Location: $lat, $lng');
          callback(lat, lng);
        }
        return;
      }

      // ─── أي حدث آخر مسجَّل عبر subscribeToPrivateChannel ───────────────
      if (event != null && channel != null) {
        final callback = _privateEventCallbacks['$channel|$event'];
        if (callback == null) return;

        final dataMap = _decodeEventData(decoded['data']);
        if (dataMap == null) return;

        callback(dataMap);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Parse error: $e');
    }
  }

  String? _extractSocketId(dynamic rawData) {
    final dataMap = _decodeEventData(rawData);
    return dataMap?['socket_id'] as String?;
  }

  Map<String, dynamic>? _decodeEventData(dynamic rawData) {
    if (rawData is String) {
      return jsonDecode(rawData) as Map<String, dynamic>;
    }
    if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    }
    return null;
  }

  void _send(Map<String, dynamic> data) {
    debugOnSend?.call(data);
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Send error: $e');
    }
  }

  void _subscribeChannel(String channelName) {
    if (_subscribedChannels.contains(channelName)) return; // ← منع التكرار
    _send({
      'event': 'pusher:subscribe',
      'data': {'channel': channelName},
    });
    _subscribedChannels.add(channelName);
    if (kDebugMode) debugPrint('📡 Subscribed: $channelName');
  }

  // ─── Subscribe على SOS (public channel) — واجهة غير معدَّلة ────────────────
  Future<void> subscribeToSosTracking({
    required int sosId,
    required LocationCallback onLocationUpdate,
  }) async {
    final channelName = 'sos.$sosId';
    _callbacks[channelName] = onLocationUpdate;

    await init();

    // ← اشترك فقط لو الاتصال موجود فعلاً
    if (_connected && !_subscribedChannels.contains(channelName)) {
      _subscribeChannel(channelName);
    }
    // إذا مو متصل بعد، الـ connection_established سيشترك تلقائياً
  }

  // ─── Unsubscribe (SOS) ──────────────────────────────────────────────────
  Future<void> unsubscribeFromSos(int sosId) async {
    final channelName = 'sos.$sosId';
    _callbacks.remove(channelName);
    _subscribedChannels.remove(channelName);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channelName},
    });
    if (kDebugMode) debugPrint('🔕 Unsubscribed: $channelName');
  }

  // ─── Subscribe على قناة خاصة (private-*) — للإشعارات وأي حدث مستقبلي ───────
  /// [channelName] must already carry the wire-protocol `private-` prefix
  /// (e.g. `private-notifications.10`); Laravel's broadcaster strips that
  /// prefix internally when matching the `Broadcast::channel()` route.
  Future<void> subscribeToPrivateChannel({
    required String channelName,
    required String eventName,
    required RawEventCallback onEvent,
    required BroadcastAuthProvider authProvider,
  }) async {
    _privateEventCallbacks['$channelName|$eventName'] = onEvent;
    _privateAuthProviders[channelName] = authProvider;

    await init();

    if (_connected && _socketId != null) {
      await _authenticateAndSubscribePrivate(channelName);
    }
    // Otherwise pusher:connection_established will trigger it once the
    // socket (re)connects and a fresh socket_id is available.
  }

  Future<void> unsubscribeFromPrivateChannel(String channelName) async {
    _privateEventCallbacks.removeWhere(
      (key, _) => key.startsWith('$channelName|'),
    );
    _privateAuthProviders.remove(channelName);
    _subscribedChannels.remove(channelName);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channelName},
    });
    if (kDebugMode) debugPrint('🔕 Unsubscribed (private): $channelName');
  }

  Future<void> _authenticateAndSubscribePrivate(String channelName) async {
    final socketId = _socketId;
    final authProvider = _privateAuthProviders[channelName];
    if (socketId == null || authProvider == null) return;
    if (_subscribedChannels.contains(channelName)) return;

    try {
      if (kDebugMode) {
        debugPrint('🔐 Private auth requested for $channelName (socket_id=$socketId)');
      }
      final auth = await authProvider(
        socketId: socketId,
        channelName: channelName,
      );
      // Never log the auth signature itself — only whether one came back.
      if (kDebugMode) {
        debugPrint(
          auth == null || auth.isEmpty
              ? '🔐 Private auth failed for $channelName (no signature returned)'
              : '🔐 Private auth succeeded for $channelName',
        );
      }
      if (auth == null || auth.isEmpty) return;

      // socket_id may have rotated again while we were awaiting the HTTP
      // call (e.g. a rapid reconnect) — a signature for the old socket_id
      // is invalid, so drop it instead of subscribing with stale auth.
      if (_socketId != socketId) return;
      if (_privateAuthProviders[channelName] == null) return; // unsubscribed meanwhile

      _send({
        'event': 'pusher:subscribe',
        'data': {'channel': channelName, 'auth': auth},
      });
      _subscribedChannels.add(channelName);
      if (kDebugMode) debugPrint('📡 Subscribed (private): $channelName');
    } catch (e) {
      // Auth failures (401/403/network) degrade gracefully — never crash,
      // never log the token/auth string itself.
      if (kDebugMode) {
        debugPrint('❌ Private channel auth failed for $channelName');
      }
    }
  }

  // ─── Disconnect ───────────────────────────────────────────────────────────
  /// [intentional] true (e.g. logout) stops the auto-reconnect scheduled by
  /// [init]'s onDone handler; a later [init]/[subscribeToSosTracking] call
  /// still connects fresh normally.
  Future<void> disconnect({bool intentional = false}) async {
    _intentionalDisconnect = intentional;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _connected = false;
    _socketId = null;
    _subscribedChannels.clear();
    _callbacks.clear();
    _privateEventCallbacks.clear();
    _privateAuthProviders.clear();
  }

  @visibleForTesting
  void debugReset() {
    debugOnSend = null;
    debugChannelFactory = null;
    _callbacks.clear();
    _privateEventCallbacks.clear();
    _privateAuthProviders.clear();
    _subscribedChannels.clear();
    _socketId = null;
    _connected = false;
  }
}
