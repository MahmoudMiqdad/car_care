import 'package:car_care/core/network/api_service.dart';

class StatisticsRemoteDataSource {

  const StatisticsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> statistics(Map<String, dynamic> data) async => _apiService.post(endPoint: 'statistics/statistics', data: data);

}
