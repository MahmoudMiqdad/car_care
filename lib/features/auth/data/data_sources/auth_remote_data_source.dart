// مسؤول عن تنفيذ طلبات تسجيل الدخول والتسجيل وتسجيل الخروج عبر واجهة API.
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<AuthResponseModel> login(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.login,
      data: data,
    );

    return AuthResponseModel.fromJson(response);
  }

  Future<AuthResponseModel> register(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.register,
      data: data,
    );

    return AuthResponseModel.fromJson(response);
  }

  Future<void> logout() async {
    await _apiService.post(endPoint: ApiEndpoints.logout);
  }

  Future<AuthResponseModel> loginWithGoogle(String idToken) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.googleLogin,
      data: {'id_token': idToken},
    );

    return AuthResponseModel.fromJson(response);
  }

  Future<String> requestPasswordReset(String email) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.forgotPassword,
      data: {'email': email},
    );

    return (response['message'] as String?) ?? '';
  }

  Future<ResetOtpVerification> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.verifyResetOtp,
      data: {'email': email, 'otp': otp},
    );

    final data = response['data'] as Map<String, dynamic>? ?? {};
    return ResetOtpVerification.fromJson(data);
  }

  Future<String> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return (response['message'] as String?) ?? '';
  }
}
