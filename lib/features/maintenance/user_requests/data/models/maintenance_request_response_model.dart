import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';

class MaintenanceRequestResponseModel {
  final bool success;
  final String? message;
  final List<MaintenanceRequestModel> data;

  MaintenanceRequestResponseModel({
    required this.success,
    this.message,
    required this.data,
  });

  factory MaintenanceRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => MaintenanceRequestModel.fromJson(e))
          .toList(),
    );
  }
}