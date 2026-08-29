// مسؤول عن تعريف عقد عمليات المصادقة: الدخول والتسجيل وتسجيل الخروج.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthResponseModel>> login(
    String email,
    String password,
  );
  Future<Either<Failure, AuthResponseModel>> register(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, Unit>> logout({String? fcmToken});

  Future<Either<Failure, AuthResponseModel>> loginWithGoogle(String idToken);

  Future<Either<Failure, String>> requestPasswordReset(String email);

  Future<Either<Failure, ResetOtpVerification>> verifyResetOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}
