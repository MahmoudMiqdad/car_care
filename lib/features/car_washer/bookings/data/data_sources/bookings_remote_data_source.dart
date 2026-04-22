import 'package:car_care/core/network/api_service.dart';

class BookingsRemoteDataSource {

  const BookingsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> bookings(Map<String, dynamic> data) async => _apiService.post(endPoint: 'bookings/bookings', data: data);

}
