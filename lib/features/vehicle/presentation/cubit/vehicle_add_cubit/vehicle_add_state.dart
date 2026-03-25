import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleAddState {
  const VehicleAddState();
}

class VehicleAddInitial extends VehicleAddState {
  const VehicleAddInitial();
}

class VehicleAddLoading extends VehicleAddState {
  const VehicleAddLoading();
}

class VehicleAddSuccess extends VehicleAddState {
  const VehicleAddSuccess(this.vehicle);

  final VehicleEntity vehicle;
}

class VehicleAddError extends VehicleAddState {
  const VehicleAddError(this.message);

  final String message;
}