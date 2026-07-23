
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/data/models/fuel_provider_statistics_model.dart';

class FuelProviderStatisticsRemoteDataSource {
  final ApiService _api;
  const FuelProviderStatisticsRemoteDataSource(this._api);

  Future<FuelProviderStatisticsModel> getStatistics() async {
    final res = await _api.get(endPoint: '${ApiEndpoints.fuelProvider}/statistics');
    return FuelProviderStatisticsModel.fromJson(res);
  }
}