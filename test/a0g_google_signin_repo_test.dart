// Data-layer coverage for Continue with Google: the request body sent to
// POST /auth/google, and that a successful response is saved through the
// exact same session-save path (_saveAuthData) as email/password login.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockSecureStorage extends Mock implements SecureStorage {}

Map<String, dynamic> _successResponse({String token = 'server-jwt'}) => {
  'success': true,
  'message': 'ok',
  'data': {
    'token': token,
    'token_type': 'Bearer',
    'user': {
      'id': 1,
      'uuid': 'u1',
      'name': 'Test User',
      'email': 't@example.com',
      'phone': null,
      'status': 'active',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-01T00:00:00Z',
      'roles': ['user'],
    },
  },
};

void main() {
  late MockApiService apiService;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    apiService = MockApiService();
    dataSource = AuthRemoteDataSource(apiService);
  });

  group('AuthRemoteDataSource.loginWithGoogle — request shape', () {
    test(
      'posts to /auth/google with exactly {"id_token": idToken}',
      () async {
        when(
          () => apiService.post(
            endPoint: any(named: 'endPoint'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => _successResponse());

        await dataSource.loginWithGoogle('expected-token');

        final captured = verify(
          () => apiService.post(
            endPoint: captureAny(named: 'endPoint'),
            data: captureAny(named: 'data'),
          ),
        ).captured;

        expect(captured[0], ApiEndpoints.googleLogin);
        expect(captured[0], '/auth/google');
        expect(captured[1], {'id_token': 'expected-token'});
      },
    );
  });

  group('AuthRepositoryImpl.loginWithGoogle — reuses the normal login save', () {
    late MockSecureStorage secureStorage;
    late AuthRepositoryImpl repo;

    setUp(() {
      secureStorage = MockSecureStorage();
      when(() => secureStorage.setToken(any())).thenAnswer((_) async {});
      when(() => secureStorage.setRoles(any())).thenAnswer((_) async {});
      when(
        () => secureStorage.setPrimaryRole(any()),
      ).thenAnswer((_) async {});
      repo = AuthRepositoryImpl(dataSource, secureStorage);
    });

    test(
      'on success, saves token/roles/primaryRole exactly like login()',
      () async {
        when(
          () => apiService.post(
            endPoint: any(named: 'endPoint'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => _successResponse(token: 'server-jwt'));

        final result = await repo.loginWithGoogle('expected-token');

        expect(result.isRight(), isTrue);
        verify(() => secureStorage.setToken('server-jwt')).called(1);
        verify(() => secureStorage.setRoles(['user'])).called(1);
        verify(() => secureStorage.setPrimaryRole('user')).called(1);
      },
    );

    test('backend failure message is preserved through the Failure flow', () async {
      when(
        () => apiService.post(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        ServerExpcptions(error: const Failure(message: 'Invalid Google token')),
      );

      final result = await repo.loginWithGoogle('bad-token');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Invalid Google token'),
        (_) => fail('expected a Left for a backend failure'),
      );
      verifyNever(() => secureStorage.setToken(any()));
    });
  });
}
