import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/data/models/fuel_provider_model.dart';

class FuelProviderProfileRemoteDataSource {
  final ApiService _api;

  const FuelProviderProfileRemoteDataSource(this._api);

  Future<FuelProviderProfileModel> addProfile(Map<String, dynamic> data) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.fuelProvider}/profile',
      data: data,
    );
    return FuelProviderProfileModel.fromJson(res);
  }

  Future<FuelProviderProfileModel> myProfile() async {
    final res = await _api.get(endPoint: '${ApiEndpoints.fuelProvider}/my_profile');
    return FuelProviderProfileModel.fromJson(res);
  }

  Future<void> updateAvailability(bool isAvailable) async {
    await _api.patch(
      endPoint: '${ApiEndpoints.fuelProvider}/availability',
      data: {'is_available': isAvailable},
    );
  }

  Future<void> updatePrices(Map<String, double> prices) async {
    await _api.patch(
      endPoint: '${ApiEndpoints.fuelProvider}/prices',
      data: {'prices': prices},
    );
  }
}