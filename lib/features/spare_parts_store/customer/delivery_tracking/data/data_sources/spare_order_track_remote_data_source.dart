// مصدر بيانات تتبع طلب قطع الغيار من API.
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/data/models/spare_order_track_model.dart';

class SpareOrderTrackRemoteDataSource {
  final ApiService _api;
  const SpareOrderTrackRemoteDataSource(this._api);

  Future<SpareOrderTrackModel> trackOrder(int orderId) async {
    final res = await _api.get(
      endPoint: ApiEndpoints.customerTrackSpareOrder(orderId),
    );
    return SpareOrderTrackModel.fromJson(res);
  }
}
