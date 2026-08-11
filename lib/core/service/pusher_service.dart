// مسؤول عن اتصال WebSocket بخدمة Reverb وإدارة اشتراكات تتبع مواقع الفنيين.
import 'dart:async';
import 'dart:convert';
import 'package:car_care/core/config/env.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef LocationCallback = void Function(double lat, double lng);

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final Map<String, LocationCallback> _callbacks = {};
  final Set<String> _subscribedChannels = {}; // ← منع الاشتراك المزدوج
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _connected = false;
  bool _intentionalDisconnect = false;

  // ─── Connect ──────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_channel != null) return;

    _intentionalDisconnect = false;
    _reconnectTimer?.cancel();

    final wsUrl =
        'ws://${Env.reverbHost}:${Env.reverbPort}/app/${Env.reverbKey}'
        '?protocol=7&client=flutter&version=1.0&flash=false';

    print('🔌 Connecting to: $wsUrl');

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: (e) => print('❌ WS Error: $e'),
      onDone: () {
        print('🔌 WS Disconnected');
        _channel = null;
        _connected = false;
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

      print('📨 Event: $event | Channel: $channel');

      // ─── لما يتصل، اشترك على كل الـ channels المنتظرة ─────────────────
      if (event == 'pusher:connection_established') {
        print('✅ Pusher connected!');
        _connected = true;
        for (final ch in _callbacks.keys) {
          if (!_subscribedChannels.contains(ch)) {
            _subscribeChannel(ch);
          }
        }
        return;
      }

      // ─── تحديث موقع الفني ─────────────────────────────────────────────
      if (event == 'location.updated' && channel != null) {
        final callback = _callbacks[channel];
        if (callback == null) return;

        final rawData = decoded['data'];
        Map<String, dynamic> dataMap;

        if (rawData is String) {
          dataMap = jsonDecode(rawData) as Map<String, dynamic>;
        } else if (rawData is Map) {
          dataMap = Map<String, dynamic>.from(rawData);
        } else {
          return;
        }

        final lat = double.tryParse(dataMap['lat'].toString());
        final lng = double.tryParse(dataMap['lng'].toString());

        if (lat != null && lng != null) {
          print('📍 Location: $lat, $lng');
          callback(lat, lng);
        }
      }
    } catch (e) {
      print('❌ Parse error: $e');
    }
  }

  void _send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      print('❌ Send error: $e');
    }
  }

  void _subscribeChannel(String channelName) {
    if (_subscribedChannels.contains(channelName)) return; // ← منع التكرار
    _send({
      'event': 'pusher:subscribe',
      'data': {'channel': channelName},
    });
    _subscribedChannels.add(channelName);
    print('📡 Subscribed: $channelName');
  }

  // ─── Subscribe على SOS ────────────────────────────────────────────────────
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

  // ─── Unsubscribe ──────────────────────────────────────────────────────────
  Future<void> unsubscribeFromSos(int sosId) async {
    final channelName = 'sos.$sosId';
    _callbacks.remove(channelName);
    _subscribedChannels.remove(channelName);
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channelName},
    });
    print('🔕 Unsubscribed: $channelName');
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
    _subscribedChannels.clear();
    _callbacks.clear();
  }
}
