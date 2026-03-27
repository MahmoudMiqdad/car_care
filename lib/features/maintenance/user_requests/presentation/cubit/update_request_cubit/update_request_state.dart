import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';

abstract class UpdateRequestState {}
class UpdateRequestInitial extends UpdateRequestState {}
class UpdateRequestLoading extends UpdateRequestState {}
class UpdateRequestSuccess extends UpdateRequestState {
  final MaintenanceRequestEntity request;
  UpdateRequestSuccess(this.request);
}
class UpdateRequestError extends UpdateRequestState {
  final String message;
  UpdateRequestError(this.message);
}