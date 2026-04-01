import 'package:car_care/core/network/api_service.dart';

class OrdersRemoteDataSource {

  const OrdersRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> orders(Map<String, dynamic> data) async => _apiService.post(endPoint: 'orders/orders', data: data);
  Future<Map<String, dynamic>> orderDetails(Map<String, dynamic> data) async => _apiService.post(endPoint: 'orders/order_details', data: data);

}
