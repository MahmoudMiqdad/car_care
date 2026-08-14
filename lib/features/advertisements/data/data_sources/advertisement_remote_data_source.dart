// مسؤول عن جلب الإعلانات الفعالة من واجهة API حسب موضع العرض.
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/advertisements/data/models/advertisement_model.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';

class AdvertisementRemoteDataSource {
  const AdvertisementRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<List<AdvertisementModel>> getActiveAdvertisements(
    AdvertisementPlacement placement,
  ) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.activeAdvertisements,
      queryParameters: {'placement': placement.apiValue},
    );
    return AdvertisementModel.listFromResponse(response);
  }
}
