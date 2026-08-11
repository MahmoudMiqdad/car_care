import 'dart:typed_data';

import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/vehicle/data/model/vehicle_model.dart';
import 'package:car_care/features/vehicle/data/model/maintenance_history_entry_model.dart';
import 'package:car_care/features/vehicle/data/model/fuel_log_model.dart';
import 'package:dio/dio.dart';

class VehicleRemoteDataSource {
  const VehicleRemoteDataSource(this._apiService);

  final ApiService _apiService;
  //my vehicle
  Future<List<VehicleModel>> getAllVehicles() async {
    final response = await _apiService.get(endPoint: ApiEndpoints.vehicles);

    final data = response['data'] as List<dynamic>? ?? [];

    return data
        .map(
          (vehicle) => VehicleModel.fromJson(vehicle as Map<String, dynamic>),
        )
        .toList();
  }

  Future<VehicleModel> addVehicle(Map<String, dynamic> data) async {
    final imageBytes = data['image_bytes'] as Uint8List?;
    final imageName = data['image_name'] as String?;

    if (imageBytes == null || imageName == null) {
      throw Exception(
        'Image bytes/name are missing. Check VehicleAddCubit keys.',
      );
    }

    final formData = FormData.fromMap({
      'brand': data['brand'],
      'model': data['model'],
      'year': data['year'],
      'plate_number': data['plate_number'],
      'current_km': data['current_km'],
      'image': MultipartFile.fromBytes(imageBytes, filename: imageName),
    });

    final response = await _apiService.post(
      endPoint: ApiEndpoints.vehicles,
      data: formData,
    );

    return VehicleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  //vehicle details
  Future<VehicleModel> getVehicleDetails(int id) async {
    final response = await _apiService.get(
      endPoint: '${ApiEndpoints.vehicles}/$id',
    );

    return VehicleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  //update vehicle
  Future<VehicleModel> updateVehicle({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final Uint8List? bytes = data['image_bytes'] as Uint8List?;
    final String? name = data['image_name'] as String?;

    final hasImage = bytes != null && name != null && name.isNotEmpty;
    const fieldKeys = ['brand', 'model', 'year', 'plate_number', 'current_km'];

    if (hasImage) {
      final formMap = <String, dynamic>{'_method': 'PUT'};
      for (final key in fieldKeys) {
        final val = data[key];
        if (val != null && (val as String).isNotEmpty) formMap[key] = val;
      }
      formMap['image'] = MultipartFile.fromBytes(bytes, filename: name);

      final formData = FormData.fromMap(formMap);

      final response = await _apiService.post(
        endPoint: '${ApiEndpoints.vehicles}/$id',
        data: formData,
      );

      return VehicleModel.fromJson(response['data'] as Map<String, dynamic>);
    }

    final body = <String, dynamic>{};
    for (final key in fieldKeys) {
      final val = data[key];
      if (val != null && (val as String).isNotEmpty) body[key] = val;
    }

    final response = await _apiService.put(
      endPoint: '${ApiEndpoints.vehicles}/$id',
      data: body,
    );

    return VehicleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  //deletevehicle
  Future<void> deleteVehicle(int id) async {
    await _apiService.delete(endPoint: '${ApiEndpoints.vehicles}/$id');
  }

  //maintenance history
  Future<List<MaintenanceHistoryEntryModel>> getMaintenanceHistory(
    int vehicleId,
  ) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.vehicleMaintenanceHistory(vehicleId),
    );

    final data = response['data'] as List<dynamic>? ?? [];

    return data
        .map(
          (e) =>
              MaintenanceHistoryEntryModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  //fuel logs
  Future<FuelLogPageModel> getFuelLogs(
    int vehicleId, {
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.vehicleFuelLogs(vehicleId),
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response['data'] as Map<String, dynamic>? ?? const {};
    return FuelLogPageModel.fromJson(data);
  }
}
