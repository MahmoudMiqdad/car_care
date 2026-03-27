// domain/entities/maintenance_request_response_entity.dart
import 'maintenance_request_entity.dart';

class MaintenanceRequestResponseEntity {
  final bool success;
  final String? message;
  final List<MaintenanceRequestEntity> data;

  MaintenanceRequestResponseEntity({
    required this.success,
    this.message,
    required this.data,
  });
}