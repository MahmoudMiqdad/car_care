import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician/technician_requests/data/models/available_requests_model.dart';
import 'package:car_care/features/technician/technician_requests/data/models/request_model.dart';

class TechnicianRequestsRemoteDataSource {

  const TechnicianRequestsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  //fetchAvailableRequests
     Future<AvailableRequestsModel> fetchAvailableRequests() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.fetchAvailableRequests,
    );
   
    return AvailableRequestsModel.fromJson(response);
  }

//fetchRequest
     Future<RequestModel> fetchRequest(String idRequest) async {
   
    final response = await _apiService.get(
      endPoint: "${ApiEndpoints.fetchRequest}/$idRequest",
    );
   
    return RequestModel.fromJson(response);
  }

}
