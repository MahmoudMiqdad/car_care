import 'dart:async';
import 'dart:convert';
import 'package:car_care/core/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef LocationCallback = void Function(double lat, double lng);
typedef RawEventCallback = void Function(Map<String, dynamic> data);

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

  final Map<String, LocationCallback> _callbacks = {};

  final Map<String, RawEventCallback> _privateEventCallbacks = {};
  final Map<String, BroadcastAuthProvider> _privateAuthProviders = {};

  final Set<String> _subscribedChannels = {};
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _connected = false;
  bool _intentionalDisconnect = false;

  String? _socketId;

  @visibleForTesting
  void Function(Map<String, dynamic> data)? debugOnSend;

  @visibleForTesting
  void debugHandleMessage(String rawMessage) => _onMessage(rawMessage);

  @visibleForTesting
  bool debugIsSubscribed(String channelName) =>
      _subscribedChannels.contains(channelName);

  @visibleForTesting
  String? get debugSocketId => _socketId;

  @visibleForTesting
  WebSocketChannel Function(Uri uri)? debugChannelFactory;

  Future<void> init() async {
    if (_channel != null) return;

    _intentionalDisconnect = false;
    _reconnectTimer?.cancel();

    final wsScheme = Env.reverbScheme == 'https' ? 'wss' : 'ws';
    final wsUrl =
        '$wsScheme://${Env.reverbHost}:${Env.reverbPort}/app/${Env.reverbKey}'
        '?protocol=7&client=flutter&version=1.0&flash=false';

    final uri = Uri.parse(wsUrl);
    _channel = (debugChannelFactory ?? WebSocketChannel.connect)(uri);

    unawaited(
      _channel!.ready.catchError((Object e) {
        if (kDebugMode) debugPrint(' WS connect failed: $e');
      }),
    );

    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: (e) {
        if (kDebugMode) debugPrint(' WS Error: $e');
      },
      onDone: () {
        _channel = null;
        _connected = false;
        _socketId = null;
        _subscribedChannels.clear();
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

      if (event == 'pusher:connection_established') {
        _connected = true;
        _socketId = _extractSocketId(decoded['data']);

        for (final ch in _callbacks.keys) {
          if (!_subscribedChannels.contains(ch)) {
            _subscribeChannel(ch);
          }
        }

        for (final channelName in _privateAuthProviders.keys.toList()) {
          unawaited(_authenticateAndSubscribePrivate(channelName));
        }
        return;
      }

      if (event == 'pusher:subscription_error' || event == 'pusher:error') {
        if (kDebugMode) {
          debugPrint(' Pusher $event on channel: ${channel ?? 'unknown'}');
        }
        return;
      }

      if (event == 'pusher_internal:subscription_succeeded') {
        return;
      }

      if (event == 'location.updated' && channel != null) {
        final callback = _callbacks[channel];
        if (callback == null) return;

        final dataMap = _decodeEventData(decoded['data']);
        if (dataMap == null) return;

        final lat = double.tryParse(dataMap['lat'].toString());
        final lng = double.tryParse(dataMap['lng'].toString());

        if (lat != null && lng != null) {
          callback(lat, lng);
        }
        return;
      }

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
    if (_subscribedChannels.contains(channelName)) return;
    _send({
      'event': 'pusher:subscribe',
      'data': {'channel': channelName},
    });
    _subscribedChannels.add(channelName);
  }

  Future<void> subscribeToSosTracking({
    required int sosId,
    required LocationCallback onLocationUpdate,
  }) async {
    final channelName = 'sos.$sosId';
    _callbacks[channelName] = onLocationUpdate;

    await init();

    if (_connected && !_subscribedChannels.contains(channelName)) {
      _subscribeChannel(channelName);
    }
  }

  Future<void> unsubscribeFromSos(int sosId) async {
    final channelName = 'sos.$sosId';
    _callbacks.remove(channelName);
    _subscribedChannels.remove(channelName);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channelName},
    });
  }

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
  }

  Future<void> _authenticateAndSubscribePrivate(String channelName) async {
    final socketId = _socketId;
    final authProvider = _privateAuthProviders[channelName];
    if (socketId == null || authProvider == null) return;
    if (_subscribedChannels.contains(channelName)) return;

    try {
      final auth = await authProvider(
        socketId: socketId,
        channelName: channelName,
      );
      if (auth == null || auth.isEmpty) return;

      if (_socketId != socketId) return;
      if (_privateAuthProviders[channelName] == null) return;

      _send({
        'event': 'pusher:subscribe',
        'data': {'channel': channelName, 'auth': auth},
      });
      _subscribedChannels.add(channelName);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(' Private channel auth failed for $channelName');
      }
    }
  }

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
