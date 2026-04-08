
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';

abstract class RequestsByStatusState {}
class RequestsByStatusInitial extends RequestsByStatusState {}
class RequestsByStatusLoading extends RequestsByStatusState {}
class RequestsByStatusLoaded extends RequestsByStatusState {
  final MaintenanceRequestEntity response;
  RequestsByStatusLoaded(this.response);
}
class RequestsByStatusError extends RequestsByStatusState {
  final String message;
  RequestsByStatusError(this.message);
}