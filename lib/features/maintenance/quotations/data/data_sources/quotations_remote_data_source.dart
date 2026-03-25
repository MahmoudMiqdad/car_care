import 'package:car_care/core/network/api_service.dart';

class QuotationsRemoteDataSource {

  const QuotationsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> quotations(Map<String, dynamic> data) async => _apiService.post(endPoint: 'quotations/quotations', data: data);

}
