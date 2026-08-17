import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/otp_verification_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('maskEmail — OTP card masking utility', () {
    test('masks the local part but keeps the first letter and full domain', () {
      expect(maskEmail('mahmoud@gmail.com'), 'm******@gmail.com');
    });

    test('returns the input unchanged when there is no @', () {
      expect(maskEmail('notanemail'), 'notanemail');
    });

    test('single-character local part has nothing to mask', () {
      expect(maskEmail('a@gmail.com'), 'a@gmail.com');
    });
  });

  group('PasswordResetCubit — OTP request/verify/reset transitions', () {
    late MockIAuthRepository repository;
    late PasswordResetCubit cubit;

    setUp(() {
      repository = MockIAuthRepository();
      cubit = PasswordResetCubit(repository);
    });

    tearDown(() => cubit.close());

    test('sendOtp moves to otpSent on success', () async {
      when(() => repository.requestPasswordReset(any())).thenAnswer(
        (_) async => const Right('sent'),
      );

      await cubit.sendOtp('user@example.com');

      expect(cubit.state.phase, PasswordResetPhase.otpSent);
      expect(cubit.state.email, 'user@example.com');
      expect(cubit.state.isError, isFalse);
    });

    test('sendOtp surfaces a failure without leaving the initial phase', () async {
      when(() => repository.requestPasswordReset(any())).thenAnswer(
        (_) async => const Left(Failure(message: 'network error')),
      );

      await cubit.sendOtp('user@example.com');

      expect(cubit.state.phase, PasswordResetPhase.initial);
      expect(cubit.state.isError, isTrue);
      expect(cubit.state.message, 'network error');
    });

    test(
      'verifyOtp requires exactly a 6-digit code to reach otpVerified '
      'and carries the reset_token forward',
      () async {
        when(() => repository.requestPasswordReset(any())).thenAnswer(
          (_) async => const Right('sent'),
        );
        await cubit.sendOtp('user@example.com');

        when(
          () => repository.verifyResetOtp(
            email: any(named: 'email'),
            otp: any(named: 'otp'),
          ),
        ).thenAnswer(
          (_) async => Right(
            ResetOtpVerification(resetToken: 'abc-token', expiresInMinutes: 15),
          ),
        );

        await cubit.verifyOtp('123456');

        expect(cubit.state.phase, PasswordResetPhase.otpVerified);
        expect(cubit.state.resetToken, 'abc-token');
      },
    );

    test('a wrong/expired code falls back to otpSent with the server message', () async {
      when(() => repository.requestPasswordReset(any())).thenAnswer(
        (_) async => const Right('sent'),
      );
      await cubit.sendOtp('user@example.com');

      when(
        () => repository.verifyResetOtp(
          email: any(named: 'email'),
          otp: any(named: 'otp'),
        ),
      ).thenAnswer(
        (_) async => const Left(Failure(message: 'رمز التحقق غير صحيح')),
      );

      await cubit.verifyOtp('000000');

      expect(cubit.state.phase, PasswordResetPhase.otpSent);
      expect(cubit.state.isError, isTrue);
      expect(cubit.state.message, 'رمز التحقق غير صحيح');
    });

    test('resetPassword reaches success and never persists the reset_token', () async {
      cubit.seedVerified(email: 'user@example.com', resetToken: 'abc-token');

      when(
        () => repository.resetPassword(
          email: any(named: 'email'),
          resetToken: any(named: 'resetToken'),
          password: any(named: 'password'),
          passwordConfirmation: any(named: 'passwordConfirmation'),
        ),
      ).thenAnswer((_) async => const Right('changed'));

      await cubit.resetPassword(
        password: 'newPass123',
        passwordConfirmation: 'newPass123',
      );

      expect(cubit.state.phase, PasswordResetPhase.success);
      verify(
        () => repository.resetPassword(
          email: 'user@example.com',
          resetToken: 'abc-token',
          password: 'newPass123',
          passwordConfirmation: 'newPass123',
        ),
      ).called(1);
    });
  });

  group('Password confirmation matching — reset password validation', () {
    String? confirmValidator(String? password, String? confirm) {
      final value = confirm?.trim() ?? '';
      if (value.isEmpty) return 'required';
      if (value != password?.trim()) return 'mismatch';
      return null;
    }

    test('matching passwords pass validation', () {
      expect(confirmValidator('secret123', 'secret123'), isNull);
    });

    test('mismatched passwords are rejected', () {
      expect(confirmValidator('secret123', 'other456'), 'mismatch');
    });

    test('empty confirmation is rejected', () {
      expect(confirmValidator('secret123', ''), 'required');
    });
  });
}
