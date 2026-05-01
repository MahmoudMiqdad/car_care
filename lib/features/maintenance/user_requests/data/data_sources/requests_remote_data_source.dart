import 'package:car_care/core/domain/entities/base_response_entity.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/network/model/base_response_model.dart' show BaseResponseModel;
import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';
import 'package:dio/dio.dart';

class RequestsRemoteDataSource {
  const RequestsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  /// getAllMaintenance
  Future<MaintenanceRequestModel> getAllMaintenance() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.maintenance,
      
    ); 
   
    return MaintenanceRequestModel.fromJson(response);
  }

  /// addMaintenanceRequest
  
  Future<BaseResponseModel> addMaintenanceRequest(
  FormData formData,
  ) async {
    final response = await _apiService.post(
   //   isFormData:true,
      endPoint: ApiEndpoints.maintenance,
      data: formData,
    );
    return BaseResponseModel  .fromJson(response);
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

