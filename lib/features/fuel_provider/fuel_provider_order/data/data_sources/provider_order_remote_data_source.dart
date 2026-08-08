
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

  /// Backend route is PATCH /fuel_provider/orders/{id}/status
  Future<FuelOrderModel> completeOrder(int id) async {
    final res = await _api.patch(
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
  /// Coordinates must stay `double` — int truncation would move the pin by
  /// tens of kilometres. Live sharing goes through
  /// ShareFuelProviderLocationRemoteDataSource; this stays for parity.
  Future<FuelOrderModel> shareLocation(
    int id,
    double latitude,
    double longitude,
  ) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.fuelProvider}/orders/$id/location',
      data: {
        "latitude": latitude,
        "longitude": longitude,
      },
    );

    return FuelOrderModel.fromJson(res);
  }
}