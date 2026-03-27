import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';

abstract class GetAllMaintenanceState {}
class GetAllMaintenanceInitial extends GetAllMaintenanceState {}
class GetAllMaintenanceLoading extends GetAllMaintenanceState {}
class GetAllMaintenanceLoaded extends GetAllMaintenanceState {
  final MaintenanceRequestResponseEntity response;
  GetAllMaintenanceLoaded(this.response);
}
class GetAllMaintenanceError extends GetAllMaintenanceState {
  final String message;
  GetAllMaintenanceError(this.message);
}
