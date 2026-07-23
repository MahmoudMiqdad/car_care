// مصدر بيانات إرسال موقع التوصيل عبر API.
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';

class OwnerShareLocationRemoteDataSource {
  final ApiService _api;
  const OwnerShareLocationRemoteDataSource(this._api);

  Future<void> shareLocation({
    required int orderId,
    required double lat,
    required double lng,
  }) async {
    await _api.post(
      endPoint: ApiEndpoints.ownerShareLocation(orderId),
      data: {'latitude': lat, 'longitude': lng},
    );
  }
}
