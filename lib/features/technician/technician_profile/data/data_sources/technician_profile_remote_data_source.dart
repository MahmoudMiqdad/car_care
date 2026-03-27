import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician/technician_profile/data/models/technician_availability_model.dart';
import 'package:car_care/features/technician/technician_profile/data/models/technician_profile.dart';

class TechnicianProfileRemoteDataSource {

  const TechnicianProfileRemoteDataSource(this._apiService);

  final ApiService _apiService;

     Future<TechnicianProfile> showProfile() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.technicianprofile,
    );
   
    return TechnicianProfile.fromJson(response);
  }

  Future<TechnicianProfile> insertTechnicianProfile(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.inserttechnicianprofile,
      data: data,
    );
    return TechnicianProfile.fromJson(response);
  }
    Future<TechnicianProfile> updateTechnicianProfile(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.updatetechnicianprofile,
      data: data,
    );
    return TechnicianProfile.fromJson(response);
  }
    Future<TechnicianAvailabilityModel> changeAvailability(String isAvailable) async {
    final response = await _apiService.patch(
      endPoint: ApiEndpoints.technicianavAilability,
      data: {"is_available":isAvailable},
    );
    return TechnicianAvailabilityModel.fromJson(response);
  }
}
