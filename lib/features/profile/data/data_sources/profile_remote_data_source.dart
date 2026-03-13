import 'package:car_care/core/network/api_service.dart';

class ProfileRemoteDataSource {

  const ProfileRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> profile(Map<String, dynamic> data) async => _apiService.post(endPoint: 'profile/profile', data: data);
  Future<Map<String, dynamic>> profileSetup(Map<String, dynamic> data) async => _apiService.post(endPoint: 'profile/profile_setup', data: data);

}
