import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_response_entity.dart';

abstract class AcceptedRequestsState {}
class AcceptedRequestsInitial extends AcceptedRequestsState {}
class AcceptedRequestsLoading extends AcceptedRequestsState {}
class AcceptedRequestsLoaded extends AcceptedRequestsState {
  final MaintenanceRequestEntity response;
  AcceptedRequestsLoaded(this.response);
}
class AcceptedRequestsError extends AcceptedRequestsState {
  final String message;
  AcceptedRequestsError(this.message);
}
