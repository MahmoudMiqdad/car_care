import 'package:car_care/core/network/api_service.dart';

class AvailabilityRemoteDataSource {

  const AvailabilityRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> availability(Map<String, dynamic> data) async => _apiService.post(endPoint: 'availability/availability', data: data);

}
