import 'package:car_care/core/network/api_service.dart';

class WashersRemoteDataSource {

  const WashersRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> washers(Map<String, dynamic> data) async => _apiService.post(endPoint: 'washers/washers', data: data);

}
