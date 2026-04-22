import 'package:car_care/core/network/api_service.dart';

class ProfileWasherRemoteDataSource {

  const ProfileWasherRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> profileWasher(Map<String, dynamic> data) async => _apiService.post(endPoint: 'profile_washer/profile_washer', data: data);

}
