// حالات إرسال موقع التوصيل للمالك.
abstract class OwnerShareLocationState {}

class OwnerShareLocationInitial extends OwnerShareLocationState {}

class OwnerShareLocationLoading extends OwnerShareLocationState {}

class OwnerShareLocationSuccess extends OwnerShareLocationState {}

class OwnerShareLocationError extends OwnerShareLocationState {
  final String message;
  OwnerShareLocationError(this.message);
}
