import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/car_washer/washers/data/models/washers_model.dart';

class WashersRemoteDataSource {
  const WashersRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<List<WasherModel>> getWashers({String? city}) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.customerCarWashers,
      queryParameters: {
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
      },
    );

    return WasherModel.listFromResponse(response);
  }
}