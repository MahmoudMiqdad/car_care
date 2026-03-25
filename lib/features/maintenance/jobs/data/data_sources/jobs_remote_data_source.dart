import 'package:car_care/core/network/api_service.dart';

class JobsRemoteDataSource {

  const JobsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> jobs(Map<String, dynamic> data) async => _apiService.post(endPoint: 'jobs/jobs', data: data);

}
