import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleDetailsState {
  const VehicleDetailsState();
}

class VehicleDetailsInitial extends VehicleDetailsState {
  const VehicleDetailsInitial();
}

class VehicleDetailsLoading extends VehicleDetailsState {
  const VehicleDetailsLoading();
}

class VehicleDetailsLoaded extends VehicleDetailsState {
  const VehicleDetailsLoaded(this.vehicle);

  final VehicleEntity vehicle;
}

class VehicleDetailsError extends VehicleDetailsState {
  const VehicleDetailsError(this.message);

  final String message;
}