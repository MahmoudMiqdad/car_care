import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/auth/domain/model/auth_modeldart';

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
}