
import 'dart:async';
import 'dart:convert';

import 'package:car_care/core/service/pusher_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late PusherService pusher;
  late StreamController<dynamic> fakeIncoming;

  setUpAll(() {
    // Env.reverbHost/Port/Key are only read by init() to build the ws:// URL
    // — the channel factory below replaces the real connect, so these
    // values are never actually dialed.
    dotenv.loadFromString(
      envString: 'REVERB_HOST=localhost\nREVERB_PORT=8080\nREVERB_KEY=test',
    );
  });

  // Fakes the WebSocket connection entirely: a broadcast stream driven only
  // by the test (so `onDone`/reconnect logic fires only when a test
  // deliberately closes it) and a sink that accepts writes silently. Tests
  // drive incoming traffic via debugHandleMessage and observe outgoing
  // frames via debugOnSend — the real wire format is exercised separately
  // by the channel-naming and dispatch-key assertions, not by round-tripping
  // actual bytes.
  void installFreshFakeChannel() {
    fakeIncoming = StreamController<dynamic>.broadcast();
    addTearDown(fakeIncoming.close);
    final sink = MockWebSocketSink();
    when(() => sink.add(any())).thenReturn(null);
    when(() => sink.close(any(), any())).thenAnswer((_) async {});
    final channel = MockWebSocketChannel();
    when(() => channel.stream).thenAnswer((_) => fakeIncoming.stream);
    when(() => channel.sink).thenReturn(sink);
    when(() => channel.ready).thenAnswer((_) => Future<void>.value());
    pusher.debugChannelFactory = (_) => channel;
  }

  setUp(() {
    pusher = PusherService();
    pusher.debugReset();
    installFreshFakeChannel();
  });

  tearDown(() async {
    await pusher.disconnect(intentional: true);
    pusher.debugReset();
  });

  String connectionEstablished(String socketId) => jsonEncode({
    'event': 'pusher:connection_established',
    'data': jsonEncode({'socket_id': socketId, 'activity_timeout': 30}),
  });

  test('public SOS subscription sends pusher:subscribe with no auth field', () async {
    final sent = <Map<String, dynamic>>[];
    pusher.debugOnSend = sent.add;

    await pusher.subscribeToSosTracking(
      sosId: 1,
      onLocationUpdate: (_, _) {},
    );
    pusher.debugHandleMessage(connectionEstablished('111.1'));

    final subscribeFrames = sent.where((f) => f['event'] == 'pusher:subscribe');
    expect(subscribeFrames, hasLength(1));
    final frame = subscribeFrames.single['data'] as Map<String, dynamic>;
    expect(frame['channel'], 'sos.1');
    expect(frame.containsKey('auth'), isFalse);
  });

  test('location.updated still invokes the SOS callback with lat/lng exactly as before', () async {
    double? gotLat;
    double? gotLng;

    await pusher.subscribeToSosTracking(
      sosId: 7,
      onLocationUpdate: (lat, lng) {
        gotLat = lat;
        gotLng = lng;
      },
    );
    pusher.debugHandleMessage(connectionEstablished('222.2'));

    pusher.debugHandleMessage(
      jsonEncode({
        'event': 'location.updated',
        'channel': 'sos.7',
        'data': jsonEncode({'lat': 30.1, 'lng': 31.2}),
      }),
    );

    expect(gotLat, 30.1);
    expect(gotLng, 31.2);
  });

  test('a private subscription waits for socket_id before authenticating', () async {
    var authCalled = false;

    await pusher.subscribeToPrivateChannel(
      channelName: 'private-notifications.10',
      eventName: 'notification.created',
      onEvent: (_) {},
      authProvider: ({required socketId, required channelName}) async {
        authCalled = true;
        return 'signature';
      },
    );

    // No connection_established fed yet — no socket_id, so no auth attempt.
    await Future<void>.delayed(Duration.zero);
    expect(authCalled, isFalse);

    pusher.debugHandleMessage(connectionEstablished('333.3'));
    await Future<void>.delayed(Duration.zero);
    expect(authCalled, isTrue);
  });

  test('successful auth sends pusher:subscribe with the returned auth string', () async {
    final sent = <Map<String, dynamic>>[];
    pusher.debugOnSend = sent.add;

    await pusher.subscribeToPrivateChannel(
      channelName: 'private-notifications.10',
      eventName: 'notification.created',
      onEvent: (_) {},
      authProvider: ({required socketId, required channelName}) async =>
          'abc:signature',
    );
    pusher.debugHandleMessage(connectionEstablished('444.4'));
    await Future<void>.delayed(Duration.zero);

    final subscribeFrames = sent.where((f) => f['event'] == 'pusher:subscribe');
    expect(subscribeFrames, hasLength(1));
    final frame = subscribeFrames.single['data'] as Map<String, dynamic>;
    expect(frame['channel'], 'private-notifications.10');
    expect(frame['auth'], 'abc:signature');
    expect(pusher.debugIsSubscribed('private-notifications.10'), isTrue);
  });

  test('reconnect with a new socket_id triggers a brand new auth request', () async {
    final socketIdsSeen = <String>[];

    await pusher.subscribeToPrivateChannel(
      channelName: 'private-notifications.10',
      eventName: 'notification.created',
      onEvent: (_) {},
      authProvider: ({required socketId, required channelName}) async {
        socketIdsSeen.add(socketId);
        return 'sig-$socketId';
      },
    );

    pusher.debugHandleMessage(connectionEstablished('socket-A'));
    await Future<void>.delayed(Duration.zero);
    expect(socketIdsSeen, ['socket-A']);

    // Simulate a real drop: closing the socket's stream fires
    // PusherService's own onDone handler, which clears _subscribedChannels
    // exactly like a genuine disconnect would. A fresh channel then
    // reconnects with a new socket_id.
    await fakeIncoming.close();
    await Future<void>.delayed(Duration.zero);
    installFreshFakeChannel();
    await pusher.init();
    pusher.debugHandleMessage(connectionEstablished('socket-B'));
    await Future<void>.delayed(Duration.zero);

    expect(socketIdsSeen, ['socket-A', 'socket-B']);
    expect(pusher.debugSocketId, 'socket-B');
  });

  test('an auth response for a socket_id that has since rotated is never subscribed with (stale auth guard)', () async {
    final sent = <Map<String, dynamic>>[];
    pusher.debugOnSend = sent.add;

    final firstAuthCompleter = Completer<String?>();

    await pusher.subscribeToPrivateChannel(
      channelName: 'private-notifications.10',
      eventName: 'notification.created',
      onEvent: (_) {},
      authProvider: ({required socketId, required channelName}) {
        if (socketId == 'socket-A') return firstAuthCompleter.future;
        return Future.value('sig-$socketId');
      },
    );

    // First connection — auth request goes out but never resolves yet.
    pusher.debugHandleMessage(connectionEstablished('socket-A'));
    await Future<void>.delayed(Duration.zero);
    expect(sent.where((f) => f['event'] == 'pusher:subscribe'), isEmpty);

    // Socket rotates before the first auth ever comes back.
    pusher.debugHandleMessage(connectionEstablished('socket-B'));
    await Future<void>.delayed(Duration.zero);

    // The stale (socket-A) auth resolves late — must be dropped, not sent.
    firstAuthCompleter.complete('sig-socket-A');
    await Future<void>.delayed(Duration.zero);

    final subscribeFrames = sent
        .where((f) => f['event'] == 'pusher:subscribe')
        .map((f) => (f['data'] as Map<String, dynamic>)['auth']);
    expect(subscribeFrames, ['sig-socket-B']);
    expect(subscribeFrames, isNot(contains('sig-socket-A')));
  });

  test('notification.created dispatches the raw payload to the registered callback', () async {
    Map<String, dynamic>? received;

    await pusher.subscribeToPrivateChannel(
      channelName: 'private-notifications.10',
      eventName: 'notification.created',
      onEvent: (data) => received = data,
      authProvider: ({required socketId, required channelName}) async => 'sig',
    );
    pusher.debugHandleMessage(connectionEstablished('555.5'));
    await Future<void>.delayed(Duration.zero);

    pusher.debugHandleMessage(
      jsonEncode({
        'event': 'notification.created',
        'channel': 'private-notifications.10',
        'data': jsonEncode({
          'id': 'uuid-1',
          'type': 'fuel_order_accepted',
          'title': 'عنوان',
          'body': 'نص',
          'data': {},
          'read_at': null,
          'created_at': '2026-08-18T10:00:00.000000Z',
        }),
      }),
    );

    expect(received, isNotNull);
    expect(received!['id'], 'uuid-1');
    expect(received!['title'], 'عنوان');
  });

  test('unrelated/unknown events never throw and leave state untouched', () async {
    await pusher.subscribeToSosTracking(sosId: 1, onLocationUpdate: (_, _) {});
    pusher.debugHandleMessage(connectionEstablished('666.6'));

    expect(
      () => pusher.debugHandleMessage(
        jsonEncode({
          'event': 'some.unrelated.event',
          'channel': 'sos.1',
          'data': {'foo': 'bar'},
        }),
      ),
      returnsNormally,
    );
    expect(
      () => pusher.debugHandleMessage('not even valid json'),
      returnsNormally,
    );
    expect(
      () => pusher.debugHandleMessage(
        jsonEncode({'event': 'pusher:subscription_error', 'channel': 'private-notifications.99'}),
      ),
      returnsNormally,
    );
  });
}
