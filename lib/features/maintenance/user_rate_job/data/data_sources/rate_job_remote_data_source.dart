import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/maintenance/user_rate_job/data/models/rate_model.dart';

class RateJobRemoteDataSource {

  const RateJobRemoteDataSource(this._apiService);

  final ApiService _apiService;

     Future<RateModel> cancelRequest(
   String review,
   String rating,
   String idQuotaions
  ) async {
    final response = await _apiService.post(
      endPoint: '${ApiEndpoints.ratejob}/$idQuotaions',
      data: {'rating':rating,'review':review},
    );
    return RateModel.fromJson(response);
  }

}
