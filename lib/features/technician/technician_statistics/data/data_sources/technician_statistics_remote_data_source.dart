import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician/technician_statistics/data/models/statistics_technician_model.dart';

class TechnicianStatisticsRemoteDataSource {

  const TechnicianStatisticsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  //fetchAvailableRequests
     Future<StatisticsTechnicianModel> statisticsTechnician() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.statisticsTechnician,
    );
   
    return StatisticsTechnicianModel.fromJson(response);
  }

}
