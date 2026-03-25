// import 'package:car_care/core/network/api_service.dart';
// import 'package:car_care/features/technician_profile/data/models/technician_profile.dart';

// class RequestsRemoteDataSource {

//   const RequestsRemoteDataSource(this._apiService);

//   final ApiService _apiService;

//   Future<TechnicianProfile> showProfile() async {


   
//     final response = await _apiService.get(
//       endPoint: ApiEndpoints.technicianprofile,
//     );
   
//     return TechnicianProfile.fromJson(response);
//   }

//   Future<TechnicianProfile> insertTechnicianProfile(Map<String, dynamic> data) async {
//     final response = await _apiService.post(
//       endPoint: ApiEndpoints.inserttechnicianprofile,
//       data: data,
//     );
//     return TechnicianProfile.fromJson(response);
//   } Future<TechnicianProfile> showProfile() async {
   
//     final response = await _apiService.get(
//       endPoint: ApiEndpoints.technicianprofile,
//     );
   
//     return TechnicianProfile.fromJson(response);
//   }

//   Future<TechnicianProfile> insertTechnicianProfile(Map<String, dynamic> data) async {
//     final response = await _apiService.post(
//       endPoint: ApiEndpoints.inserttechnicianprofile,
//       data: data,
//     );
//     return TechnicianProfile.fromJson(response);
//   }
