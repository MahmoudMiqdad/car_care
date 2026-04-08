import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final MaintenanceRequestEntity response;
  final RequestStatus status;

  RequestsLoaded(this.response, this.status);
}

class RequestsError extends RequestsState {
  final String message;

  RequestsError(this.message);
}
