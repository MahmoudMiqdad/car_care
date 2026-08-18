// اختبارات broadcasting auth: التأكد أن جسم الطلب يحوي socket_id
// و channel_name بالضبط، وأنه يمر عبر ApiService الموجود (المصادق تلقائيًا
// عبر AuthInterceptor)، دون تكرار HTTP stack جديد، وأن الرابط لا يرث
// بادئة /api لأن Broadcast::routes() مسجّل خارجها.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:car_care/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  // Env.baseUrl (used to derive the broadcasting-auth absolute URL) reads
  // through flutter_dotenv, same as production.
  setUpAll(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://api-carcarex.futxtech.com/api');
  });

  const expectedAuthUrl = 'https://api-carcarex.futxtech.com/broadcasting/auth';

  group('NotificationsRemoteDataSource.broadcastAuth', () {
    late MockApiService api;
    late NotificationsRemoteDataSource dataSource;

    setUp(() {
      api = MockApiService();
      dataSource = NotificationsRemoteDataSource(api);
    });

    test(
      'posts to the bare-host broadcasting/auth URL, NOT under the /api prefix '
      '(Broadcast::routes() is registered outside routes/api.php)',
      () async {
        when(
          () => api.post(
            endPoint: expectedAuthUrl,
            data: {'socket_id': 's-1', 'channel_name': 'private-notifications.10'},
          ),
        ).thenAnswer((_) async => {'auth': 'key:signature'});

        final auth = await dataSource.broadcastAuth(
          socketId: 's-1',
          channelName: 'private-notifications.10',
        );

        expect(auth, 'key:signature');
        verify(
          () => api.post(
            endPoint: expectedAuthUrl,
            data: {'socket_id': 's-1', 'channel_name': 'private-notifications.10'},
          ),
        ).called(1);
      },
    );

    test('goes through the shared ApiService (same authenticated Dio client '
        'as every other request) — no separate HTTP stack', () async {
      when(
        () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
      ).thenAnswer((_) async => {'auth': 'x'});

      await dataSource.broadcastAuth(socketId: 's', channelName: 'c');

      // The only network call made is through the injected ApiService —
      // proven simply by the fact this test never touches Dio/HttpClient.
      verify(
        () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
      ).called(1);
    });

    test(
      'a bare top-level {"auth": "..."} response (the real Reverb shape) is '
      'read directly — never assumed to be wrapped under "data"',
      () async {
        when(
          () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
        ).thenAnswer((_) async => {'auth': 'app-key:deadbeef'});

        final auth = await dataSource.broadcastAuth(
          socketId: 's',
          channelName: 'private-notifications.27',
        );

        expect(auth, 'app-key:deadbeef');
      },
    );

    test(
      'when the broadcasting/auth response bypasses Content-Type-based JSON '
      'auto-decoding, ApiService wraps the raw body text as {"data": '
      '"<json string>"} — this must still be unwrapped down to the auth '
      'signature instead of silently returning null',
      () async {
        when(
          () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
        ).thenAnswer(
          (_) async => {'data': '{"auth":"app-key:from-raw-string"}'},
        );

        final auth = await dataSource.broadcastAuth(
          socketId: 's',
          channelName: 'private-notifications.27',
        );

        expect(auth, 'app-key:from-raw-string');
      },
    );

    test(
      'a malformed/unrecognized response shape returns null safely instead '
      'of throwing',
      () async {
        when(
          () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
        ).thenAnswer((_) async => {'data': 'not even json'});

        final auth = await dataSource.broadcastAuth(
          socketId: 's',
          channelName: 'private-notifications.27',
        );

        expect(auth, isNull);
      },
    );

    test('a response with neither "auth" nor "data" returns null safely', () async {
      when(
        () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
      ).thenAnswer((_) async => <String, dynamic>{});

      final auth = await dataSource.broadcastAuth(
        socketId: 's',
        channelName: 'private-notifications.27',
      );

      expect(auth, isNull);
    });
  });

  group('NotificationsRepositoryImpl.getBroadcastAuth', () {
    late MockApiService api;
    late NotificationsRepositoryImpl repo;

    setUp(() {
      api = MockApiService();
      repo = NotificationsRepositoryImpl(NotificationsRemoteDataSource(api));
    });

    test('a 401/403 from broadcasting/auth surfaces as a Failure, not a crash', () async {
      when(
        () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
      ).thenThrow(Exception('401'));

      final result = await repo.getBroadcastAuth(
        socketId: 's',
        channelName: 'private-notifications.10',
      );

      expect(result.isLeft(), isTrue);
      expect(result, isA<Left<Failure, String>>());
    });

    test('a successful response yields Right(auth)', () async {
      when(
        () => api.post(endPoint: any(named: 'endPoint'), data: any(named: 'data')),
      ).thenAnswer((_) async => {'auth': 'signed'});

      final result = await repo.getBroadcastAuth(
        socketId: 's',
        channelName: 'private-notifications.10',
      );

      expect(result, const Right<Failure, String>('signed'));
    });
  });
}
