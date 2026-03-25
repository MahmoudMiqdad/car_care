import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleState {
  const VehicleState();
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleLoaded extends VehicleState {
  const VehicleLoaded(this.vehicles);

  final List<VehicleEntity> vehicles;
}

class VehicleEmpty extends VehicleState {
  const VehicleEmpty();
}

class VehicleError extends VehicleState {
  const VehicleError(this.message);

  final String message;
}

