
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';

/// الحالات الخاصة بإلغاء الطلب
abstract class CancelRequestState {}

class CancelRequestInitial extends CancelRequestState {}

class CancelRequestLoading extends CancelRequestState {}

class CancelRequestSuccess extends CancelRequestState {
  final MaintenanceRequestEntity request;
  CancelRequestSuccess(this.request);
}

class CancelRequestError extends CancelRequestState {
  final String message;
  CancelRequestError(this.message);
}