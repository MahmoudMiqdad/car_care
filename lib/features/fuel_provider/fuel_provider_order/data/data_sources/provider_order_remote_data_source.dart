
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/data/models/fuel_provider_order_model.dart';

class FuelProviderOrderRemoteDataSource {
  final ApiService _api;
  const FuelProviderOrderRemoteDataSource(this._api);

  Future<FuelOrderModel> getOrder(int id) async {
    final res = await _api.get(endPoint: '${ApiEndpoints.fuelProvider}/orders/$id');
    return FuelOrderModel.fromJson(res);
  }

  Future<FuelOrderModel> acceptOrder(int id) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.fuelProvider}/orders/$id/accept',
      data: {},
    );
    return FuelOrderModel.fromJson(res);
  }

  Future<FuelOrderModel> completeOrder(int id) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.fuelProvider}/orders/$id/status',
      data: {'status': 'completed'},
    );
    return FuelOrderModel.fromJson(res);
  }

  Future<FuelOrderModel> cancelOrder(int id, String reason) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.fuelProvider}/orders/$id/cancel',
      data: {'cancellation_reason': reason},
    );
    return FuelOrderModel.fromJson(res);
  }

  Future<FuelOrderListModel> getMyOrders() async {
    final res = await _api.get(endPoint: '${ApiEndpoints.fuelProvider}/my_orders');
    return FuelOrderListModel.fromJson(res);
  }
    Future<FuelOrderListModel> getavailableOrders() async {
    final res = await _api.get(endPoint: '${ApiEndpoints.fuelProvider}/available_orders');
    return FuelOrderListModel.fromJson(res);
  }
    Future<FuelOrderModel> ShareLocation(int id  ,int latitude ,int longitude) async {
    final res = await _api.post(endPoint: '${ApiEndpoints.fuelProvider}/orders/$id/location',
    data: {
    "latitude": latitude,
    "longitude": longitude
}
    );
    
    return FuelOrderModel.fromJson(res);
  }
}