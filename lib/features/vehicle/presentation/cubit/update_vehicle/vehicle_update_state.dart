import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleUpdateState {
  const VehicleUpdateState();
}

class VehicleUpdateInitial extends VehicleUpdateState {
  const VehicleUpdateInitial();
}

class VehicleUpdateLoading extends VehicleUpdateState {
  const VehicleUpdateLoading();
}

class VehicleUpdateSuccess extends VehicleUpdateState {
  const VehicleUpdateSuccess(this.vehicle);
  final VehicleEntity vehicle;
}

class VehicleUpdateError extends VehicleUpdateState {
  const VehicleUpdateError(this.message);
  final String message;
}