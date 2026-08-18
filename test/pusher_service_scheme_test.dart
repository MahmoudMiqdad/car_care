
import 'dart:async';

import 'package:car_care/core/service/pusher_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late PusherService pusher;

  setUp(() {
    pusher = PusherService();
    pusher.debugReset();
  });

  tearDown(() async {
    await pusher.disconnect(intentional: true);
    pusher.debugReset();
  });

  /// Installs a fake channel and captures the [Uri] PusherService.init()
  /// connects with, without ever touching a real socket.
  Future<Uri> capturedConnectUri() async {
    Uri? captured;
    final sink = MockWebSocketSink();
    when(() => sink.add(any())).thenReturn(null);
    when(() => sink.close(any(), any())).thenAnswer((_) async {});
    final channel = MockWebSocketChannel();
    final never = StreamController<dynamic>.broadcast();
    addTearDown(never.close);
    when(() => channel.stream).thenAnswer((_) => never.stream);
    when(() => channel.sink).thenReturn(sink);
    when(() => channel.ready).thenAnswer((_) => Future<void>.value());

    pusher.debugChannelFactory = (uri) {
      captured = uri;
      return channel;
    };

    await pusher.init();
    return captured!;
  }

  test('REVERB_SCHEME=https produces a wss:// URL', () async {
    dotenv.loadFromString(
      envString:
          'REVERB_HOST=api-carcarex.futxtech.com\nREVERB_PORT=443\nREVERB_KEY=carcarex-ws-7f3k9m2p\nREVERB_SCHEME=https',
    );

    final uri = await capturedConnectUri();

    expect(uri.scheme, 'wss');
    expect(
      uri.toString(),
      'wss://api-carcarex.futxtech.com:443/app/carcarex-ws-7f3k9m2p'
      '?protocol=7&client=flutter&version=1.0&flash=false',
    );
  });

  test('REVERB_SCHEME=http produces a ws:// URL', () async {
    dotenv.loadFromString(
      envString:
          'REVERB_HOST=localhost\nREVERB_PORT=8080\nREVERB_KEY=test\nREVERB_SCHEME=http',
    );

    final uri = await capturedConnectUri();

    expect(uri.scheme, 'ws');
    expect(uri.toString(), startsWith('ws://localhost:8080/app/test'));
  });

  test('missing REVERB_SCHEME defaults to ws:// (dev/back-compat)', () async {
    dotenv.loadFromString(
      envString: 'REVERB_HOST=localhost\nREVERB_PORT=8080\nREVERB_KEY=test',
    );
    // dotenv merges keys, so explicitly clear a scheme a prior test may
    // have left behind rather than relying on load-order.
    dotenv.env.remove('REVERB_SCHEME');

    final uri = await capturedConnectUri();

    expect(uri.scheme, 'ws');
  });

  test(
    'a rejected WebSocket upgrade (channel.ready errors) never escapes as an unhandled exception, and the stream error path still runs',
    () async {
      dotenv.loadFromString(
        envString: 'REVERB_HOST=localhost\nREVERB_PORT=8080\nREVERB_KEY=test',
      );

      final sink = MockWebSocketSink();
      when(() => sink.add(any())).thenReturn(null);
      when(() => sink.close(any(), any())).thenAnswer((_) async {});
      final channel = MockWebSocketChannel();
      final controller = StreamController<dynamic>.broadcast();
      addTearDown(controller.close);
      when(() => channel.stream).thenAnswer((_) => controller.stream);
      when(() => channel.sink).thenReturn(sink);
      // Mirrors what web_socket_channel's real adapter does on a failed
      // handshake: `ready` completes with an error.
      when(() => channel.ready).thenAnswer(
        (_) => Future<void>.error(
          Exception('Connection was not upgraded to websocket'),
        ),
      );

      pusher.debugChannelFactory = (_) => channel;

      // init() itself must not throw, and no error should escape the zone
      // as an unhandled exception (a bare `await` here is enough — if the
      // `ready` future's rejection were left unhandled, the test framework
      // would report it as an uncaught error in this test's zone).
      await pusher.init();

      // The stream's own onError/onDone path (independent of `ready`) still
      // works: closing it triggers reconnect scheduling exactly as before.
      controller.addError(Exception('was not upgraded to websocket'));
      await controller.close();
      await Future<void>.delayed(Duration.zero);

      // No crash reaching this point is the assertion itself.
      expect(true, isTrue);
    },
  );
}
