import 'package:car_care/core/network/api_service.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async => _apiService.post(endPoint: 'auth/login', data: data);
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async => _apiService.post(endPoint: 'auth/register', data: data);
}