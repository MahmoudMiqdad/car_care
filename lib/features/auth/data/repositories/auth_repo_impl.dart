import 'dart:async';

import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/service/fcm_service.dart';
import 'package:car_care/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:car_care/features/auth/data/services/google_sign_in_service.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._secureStorage, {
    GoogleSignInService? googleSignInService,
    FcmService? fcmService,
  }) : _googleSignInService = googleSignInService,
       _fcmService = fcmService;

  final AuthRemoteDataSource _authRemoteDataSource;
  final SecureStorage _secureStorage;
  final GoogleSignInService? _googleSignInService;
  final FcmService? _fcmService;

  static const _rolePriority = [
    'admin',
    'shop-owner',
    'technician',
    'car-washer',
    'fuel-provider',
    'user',
  ];

  static String _pickPrimaryRole(List<String> roles) {
    for (final priority in _rolePriority) {
      if (roles.contains(priority)) return priority;
    }
    return roles.isNotEmpty ? roles.first : 'user';
  }

  Future<void> _saveAuthData(AuthResponseModel result) async {
    await _secureStorage.setToken(result.token!);
    final roles = result.user?.roles ?? [];
    if (roles.isNotEmpty) {
      await _secureStorage.setRoles(roles);
      await _secureStorage.setPrimaryRole(_pickPrimaryRole(roles));
    }
    unawaited(_fcmService?.syncTokenForAuthenticatedUser());
  }

  @override
  Future<Either<Failure, AuthResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _authRemoteDataSource.login({
        'email': email.trim(),
        'password': password.trim(),
      });

      if (result.token != null && result.token!.isNotEmpty) {
        await _saveAuthData(result);
        return Right(result);
      } else {
        return Left(Failure(message: 'Email أو كلمة المرور غير صحيحة'));
      }
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> register(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _authRemoteDataSource.register(data);

      if (result.token != null && result.token!.isNotEmpty) {
        await _saveAuthData(result);
        return Right(result);
      } else {
        return Left(
          Failure(message: 'حدث خطأ أثناء التسجيل، تحقق من البيانات'),
        );
      }
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await _googleSignInService?.signOut();

    try {
      await _authRemoteDataSource.logout();
      return const Right(unit);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'تعذر تسجيل الخروج من الخادم'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> loginWithGoogle(
    String idToken,
  ) async {
    try {
      final result = await _authRemoteDataSource.loginWithGoogle(idToken);

      if (result.token != null && result.token!.isNotEmpty) {
        await _saveAuthData(result);
        return Right(result);
      } else {
        return Left(Failure(message: 'تعذر تسجيل الدخول عبر Google'));
      }
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }

  @override
  Future<Either<Failure, String>> requestPasswordReset(String email) async {
    try {
      final message = await _authRemoteDataSource.requestPasswordReset(
        email.trim(),
      );
      return Right(message);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }

  @override
  Future<Either<Failure, ResetOtpVerification>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _authRemoteDataSource.verifyResetOtp(
        email: email.trim(),
        otp: otp.trim(),
      );
      return Right(result);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final message = await _authRemoteDataSource.resetPassword(
        email: email.trim(),
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(message);
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    }
  }
}
