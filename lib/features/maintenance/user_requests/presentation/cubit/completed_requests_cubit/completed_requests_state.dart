import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';

abstract class CompletedRequestsState {}
class CompletedRequestsInitial extends CompletedRequestsState {}
class CompletedRequestsLoading extends CompletedRequestsState {}
class CompletedRequestsLoaded extends CompletedRequestsState {
  final MaintenanceRequestEntity response;
  CompletedRequestsLoaded(this.response);
}
class CompletedRequestsError extends CompletedRequestsState {
  final String message;
  CompletedRequestsError(this.message);
}