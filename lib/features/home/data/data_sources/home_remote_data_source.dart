import 'package:car_care/core/network/api_service.dart';

class HomeRemoteDataSource {

  const HomeRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> home(Map<String, dynamic> data) async => _apiService.post(endPoint: 'home/home', data: data);

}
