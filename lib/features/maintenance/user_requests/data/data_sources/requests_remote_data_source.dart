import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_response_model.dart';

class RequestsRemoteDataSource {
  const RequestsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  /// getAllMaintenance
  Future<MaintenanceRequestModel> getAllMaintenance() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.maintenance,
      
    ); 
     print('88888888888888888888888888888888888888888888888888888888888888'); 
       print(response); 
    return MaintenanceRequestModel.fromJson(response);
  }

  /// addMaintenanceRequest
  
  Future<MaintenanceRequestModel> addMaintenanceRequest(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.maintenance,
      data: data,
    );
    return MaintenanceRequestModel.fromJson(response);
  }
  //cancelRequest
    Future<MaintenanceRequestModel> cancelRequest(
   String cancellationReason,
   String id
  ) async {
    final response = await _apiService.post(
      endPoint: '${ApiEndpoints.maintenance}/$id/cancel',
      data: cancellationReason,
    );
    return MaintenanceRequestModel.fromJson(response);
  }

  /// showRequest
 
  Future<MaintenanceRequestModel> showRequest(String id) async {
    final response = await _apiService.get(
      endPoint: '${ApiEndpoints.technicianprofile}/$id',
    );

    return MaintenanceRequestModel.fromJson(response);
  }

  /// updateRequest
 
  Future<MaintenanceRequestModel> updateRequest(String id, Map<String, dynamic> data) async {
    final response = await _apiService.put(
      endPoint: ApiEndpoints.maintenance,
      id: id,
    );
    return MaintenanceRequestModel.fromJson(response);
  }

  /// deletRequest
 
  Future<MaintenanceRequestModel> deletRequest(String id) async {
    final response = await _apiService.delete(
      id: id,
      endPoint: ApiEndpoints.maintenance,
    );
    return MaintenanceRequestModel.fromJson(response);
  }

  /// pendingRequests
 
  Future<MaintenanceRequestModel> pendingRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.pendingRequests,
    );

    return MaintenanceRequestModel.fromJson(response);
  }

  /// completedRequests
 
  Future<MaintenanceRequestModel> completedRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.completedRequests,
    );

    return MaintenanceRequestModel.fromJson(response);
  }

  /// acceptedRequests
 
  Future<MaintenanceRequestModel> acceptedRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.acceptedRequests,
    );

    return MaintenanceRequestModel.fromJson(response);
  }
}

