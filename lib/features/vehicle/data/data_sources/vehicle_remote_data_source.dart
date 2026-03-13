import 'package:car_care/core/network/api_service.dart';

class VehicleRemoteDataSource {

  const VehicleRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> myVehiclesPage(Map<String, dynamic> data) async => _apiService.post(endPoint: 'vehicle/my_vehicles_page', data: data);
  Future<Map<String, dynamic>> addVehicle(Map<String, dynamic> data) async => _apiService.post(endPoint: 'vehicle/add_vehicle', data: data);
  Future<Map<String, dynamic>> vehicleDetails(Map<String, dynamic> data) async => _apiService.post(endPoint: 'vehicle/vehicle_details', data: data);

}
