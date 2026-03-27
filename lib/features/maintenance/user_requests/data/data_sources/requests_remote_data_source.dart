import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_response_model.dart';

class RequestsRemoteDataSource {
  const RequestsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  /// getAllMaintenance
  Future<MaintenanceRequestResponseModel> getAllMaintenance() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.maintenance,
    );

    return MaintenanceRequestResponseModel.fromJson(response);
  }

  /// addMaintenanceRequest
  
  Future<MaintenanceRequestResponseModel> addMaintenanceRequest(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.maintenance,
      data: data,
    );
    return MaintenanceRequestResponseModel.fromJson(response);
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
 
  Future<MaintenanceRequestResponseModel> pendingRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.pendingRequests,
    );

    return MaintenanceRequestResponseModel.fromJson(response);
  }

  /// completedRequests
 
  Future<MaintenanceRequestResponseModel> completedRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.completedRequests,
    );

    return MaintenanceRequestResponseModel.fromJson(response);
  }

  /// acceptedRequests
 
  Future<MaintenanceRequestResponseModel> acceptedRequests() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.acceptedRequests,
    );

    return MaintenanceRequestResponseModel.fromJson(response);
  }
}

