import 'package:car_care/features/technician/technician_profile/domain/entities/technician_availability_entity.dart';

abstract class TechnicianAvailabilityState {
  const TechnicianAvailabilityState();
}

class TechnicianAvailabilityInitial extends TechnicianAvailabilityState {}

class TechnicianAvailabilityLoading extends TechnicianAvailabilityState {}

class TechnicianAvailabilitySuccess extends TechnicianAvailabilityState {
  final TechnicianAvailabilityEntity data;

  const TechnicianAvailabilitySuccess(this.data);
}

class TechnicianAvailabilityError extends TechnicianAvailabilityState {
  final String message;

  const TechnicianAvailabilityError(this.message);
}