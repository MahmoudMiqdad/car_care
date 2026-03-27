import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';

abstract class PendingRequestsState {}
class PendingRequestsInitial extends PendingRequestsState {}
class PendingRequestsLoading extends PendingRequestsState {}
class PendingRequestsLoaded extends PendingRequestsState {
  final MaintenanceRequestResponseEntity response;
  PendingRequestsLoaded(this.response);
}
class PendingRequestsError extends PendingRequestsState {
  final String message;
  PendingRequestsError(this.message);
}
