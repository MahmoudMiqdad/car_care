// AuthBloc coverage for GoogleSignInRequested: cancellation and missing-token
// must never reach the backend; success/failure reuse the existing
// AuthSuccess/AuthFailure states; plain email/password login is unaffected.
import 'package:bloc_test/bloc_test.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/auth/data/services/google_sign_in_service.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

AuthResponseModel _successModel() => AuthResponseModel.fromJson({
  'success': true,
  'message': 'ok',
  'data': {
    'token': 'server-jwt',
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
});

void main() {
  late MockIAuthRepository repo;
  late MockGoogleSignInService googleService;

  setUp(() {
    repo = MockIAuthRepository();
    googleService = MockGoogleSignInService();
  });

  AuthBloc buildBloc() =>
      AuthBloc(repo, googleSignInService: googleService);

  group('GoogleSignInRequested — cancellation and missing token', () {
    blocTest<AuthBloc, AuthState>(
      'user cancels the Google picker: no backend request, no state change',
      setUp: () {
        when(
          () => googleService.signInAndGetIdToken(),
        ).thenAnswer((_) async => null);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      verify: (_) {
        verifyNever(() => repo.loginWithGoogle(any()));
      },
      expect: () => <Matcher>[],
    );

    blocTest<AuthBloc, AuthState>(
      'idToken missing (account returned without a token): clear failure, '
      'no backend request',
      setUp: () {
        when(
          () => googleService.signInAndGetIdToken(),
        ).thenThrow(const GoogleIdTokenMissingException());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      verify: (_) {
        verifyNever(() => repo.loginWithGoogle(any()));
      },
      expect: () => [isA<AuthFailure>(), isA<AuthFormState>()],
    );

    blocTest<AuthBloc, AuthState>(
      'Google SDK/config error: clear failure, no backend request',
      setUp: () {
        when(() => googleService.signInAndGetIdToken()).thenThrow(
          const GoogleSignInException(
            code: GoogleSignInExceptionCode.clientConfigurationError,
            description: 'bad config',
          ),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      verify: (_) {
        verifyNever(() => repo.loginWithGoogle(any()));
      },
      expect: () => [isA<AuthFailure>(), isA<AuthFormState>()],
    );
  });

  group('GoogleSignInRequested — happy path and backend failure', () {
    blocTest<AuthBloc, AuthState>(
      'idToken obtained: repository receives that exact token and '
      'AuthSuccess is emitted',
      setUp: () {
        when(
          () => googleService.signInAndGetIdToken(),
        ).thenAnswer((_) async => 'expected-token');
        when(
          () => repo.loginWithGoogle(any()),
        ).thenAnswer((_) async => Right(_successModel()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      verify: (_) {
        verify(() => repo.loginWithGoogle('expected-token')).called(1);
      },
      expect: () => [isA<AuthFormState>(), isA<AuthSuccess>()],
    );

    blocTest<AuthBloc, AuthState>(
      'backend rejects the Google token: the server message is preserved',
      setUp: () {
        when(
          () => googleService.signInAndGetIdToken(),
        ).thenAnswer((_) async => 'bad-token');
        when(() => repo.loginWithGoogle(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'رمز Google غير صالح')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        isA<AuthFormState>(),
        isA<AuthFailure>().having(
          (s) => s.message,
          'message',
          'رمز Google غير صالح',
        ),
        isA<AuthFormState>(),
      ],
    );
  });

  group('SubmitLogin (email/password) — unaffected by the Google addition', () {
    blocTest<AuthBloc, AuthState>(
      'still calls repo.login(email, password) and never touches Google',
      setUp: () {
        when(
          () => repo.login(any(), any()),
        ).thenAnswer((_) async => Right(_successModel()));
      },
      build: buildBloc,
      act: (bloc) {
        bloc.add(EmailChanged('user@example.com'));
        bloc.add(PasswordChanged('secret123'));
        bloc.add(SubmitLogin());
      },
      verify: (_) {
        verify(() => repo.login('user@example.com', 'secret123')).called(1);
        verifyNever(() => googleService.signInAndGetIdToken());
        verifyNever(() => repo.loginWithGoogle(any()));
      },
    );
  });
}
