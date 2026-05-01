import '../../../domain/entities/car_wash_booking_entity.dart';

abstract class CarWashBookingState {}

class CarWashBookingInitial extends CarWashBookingState {}

class CarWashBookingSubmitting extends CarWashBookingState {}

class CarWashBookingSuccess extends CarWashBookingState {
  CarWashBookingSuccess(this.data);
  final CarWashBookingEntity data;
}

class CarWashBookingError extends CarWashBookingState {
  CarWashBookingError(this.message);
  final String message;
}