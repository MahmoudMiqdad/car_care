import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';

class AvailabilityRemoteDataSource {
  const AvailabilityRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> updateAvailability(bool isAvailable) {
    return _apiService.patch(
      endPoint: ApiEndpoints.washerAvailability,
      data: {'is_available': isAvailable},
    );
  }
}
