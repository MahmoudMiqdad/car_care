import 'package:car_care/core/network/api_service.dart';

class RatingsRemoteDataSource {

  const RatingsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> ratings(Map<String, dynamic> data) async => _apiService.post(endPoint: 'ratings/ratings', data: data);

}
