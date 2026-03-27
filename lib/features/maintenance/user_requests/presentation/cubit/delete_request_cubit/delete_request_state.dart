import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';

abstract class DeleteRequestState {}
class DeleteRequestInitial extends DeleteRequestState {}
class DeleteRequestLoading extends DeleteRequestState {}
class DeleteRequestSuccess extends DeleteRequestState {
  final MaintenanceRequestEntity request;
  DeleteRequestSuccess(this.request);
}
class DeleteRequestError extends DeleteRequestState {
  final String message;
  DeleteRequestError(this.message);
}