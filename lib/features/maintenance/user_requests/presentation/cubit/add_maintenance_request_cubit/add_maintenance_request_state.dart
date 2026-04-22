
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';

abstract class AddMaintenanceRequestState {}
class AddMaintenanceRequestInitial extends AddMaintenanceRequestState {}
class AddMaintenanceRequestLoading extends AddMaintenanceRequestState {}
class AddMaintenanceRequestSuccess extends AddMaintenanceRequestState {
  final MaintenanceRequestEntity response;
  AddMaintenanceRequestSuccess(this.response);
}
class AddMaintenanceRequestError extends AddMaintenanceRequestState {
  final String message;
  AddMaintenanceRequestError(this.message);
}
