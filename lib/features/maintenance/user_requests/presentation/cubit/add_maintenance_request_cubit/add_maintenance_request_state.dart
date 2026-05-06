
import 'package:car_care/core/domain/entities/base_response_entity.dart';

abstract class AddMaintenanceRequestState {}
class AddMaintenanceRequestInitial extends AddMaintenanceRequestState {}
class AddMaintenanceRequestLoading extends AddMaintenanceRequestState {}
class AddMaintenanceRequestSuccess extends AddMaintenanceRequestState {
  final BaseResponseEntity  response;
  AddMaintenanceRequestSuccess(this.response);
}
class AddMaintenanceRequestError extends AddMaintenanceRequestState {
  final String message;
  AddMaintenanceRequestError(this.message);
}
