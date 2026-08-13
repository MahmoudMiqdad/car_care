import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/data/models/car_washer_rating_model.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';

class CarWasherRatingsRemoteDataSource {
  const CarWasherRatingsRemoteDataSource(this._apiService);
  final ApiService _apiService;

  Future<CarWasherRatingsPageEntity> getRatings(
    int carWasherId, {
    int page = 1,
  }) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.customerCarWasherRatings(carWasherId),
      queryParameters: {'page': page},
    );

    return CarWasherRatingsPageModel.fromJson(response);
  }
}
