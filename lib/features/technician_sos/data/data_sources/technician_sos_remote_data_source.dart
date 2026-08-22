import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician_sos/data/models/technician_sos_model.dart';
import 'package:car_care/features/technician_sos/data/models/update_request_status_technician_model.dart';

class TechnicianSosRemoteDataSource {
  final ApiService _api;

  TechnicianSosRemoteDataSource(this._api);


  Future<List<TechnicianSosData>> getAvailableRequests() async {
    final res = await _api.get(
      endPoint: ApiEndpoints.technicianSosAvailable,
    );

    return List.from(res['data'])
        .map((e) => TechnicianSosData.fromJson(e))
        .toList();
  }


  Future<TechnicianSosData> getRequest(int id) async {
    final res = await _api.get(
      endPoint: '${ApiEndpoints.technicianSosRequests}/$id',
    );

    return TechnicianSosData.fromJson(res['data']);
  }

  Future<TechnicianSosData> acceptRequest(int id) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.technicianSosRequests}/$id/accept',
      data: {},
    );

    return TechnicianSosData.fromJson(res['data']);
  }

  Future<TechnicianSosModel> cancelResponse(int id, String reason) async {
    final res = await _api.post(
      endPoint: '${ApiEndpoints.technicianSosRequests}/$id/cancel',
      data: {"cancellation_reason": reason},
    );

    return TechnicianSosModel.fromJson(res);
  }

  Future<TechnicianSosData> updateStatus(int id, String status) async {
    final res = await _api.patch(
      endPoint: '${ApiEndpoints.technicianSosRequests}/$id/status',
      data: {"status": status},
    );

    return TechnicianSosData.fromJson(res['data']);
  }


  Future<List<TechnicianSosData>> myRequests() async {
    final res = await _api.get(
      endPoint: ApiEndpoints.technicianSosMyRequests,
    );

    return List.from(res['data'])
        .map((e) => TechnicianSosData.fromJson(e))
        .toList();
  }


  Future<Map<String, dynamic>> statistics() async {
    return await _api.get(
      endPoint:ApiEndpoints.technicianSosStatistics,
    );
  }



    Future<UpdateRequestStatusTechnicianData> shareLocation({
    required int sosId,
    required double lat,
    required double lng,
  }) async {
    final res = await _api.post(
      endPoint: "/sos/$sosId/location",
      data: {
        "lat": lat,
        "lng": lng,
      },
    );

    return UpdateRequestStatusTechnicianData.fromJson(res['data']);
  }
}