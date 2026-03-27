import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/maintenance/user_statistics/data/models/statistics_model.dart';

class StatisticsRemoteDataSource {

  const StatisticsRemoteDataSource(this._apiService);

  final ApiService _apiService;

      Future<StatisticsModel> statistics() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.statisticsUser,
    );
   
    return StatisticsModel.fromJson(response);
  }

}
