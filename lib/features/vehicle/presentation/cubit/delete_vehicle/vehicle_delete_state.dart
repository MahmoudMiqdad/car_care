abstract class VehicleDeleteState {
  const VehicleDeleteState();
}

class VehicleDeleteInitial extends VehicleDeleteState {
  const VehicleDeleteInitial();
}

class VehicleDeleteLoading extends VehicleDeleteState {
  const VehicleDeleteLoading();
}

class VehicleDeleteSuccess extends VehicleDeleteState {
  const VehicleDeleteSuccess();
}

class VehicleDeleteError extends VehicleDeleteState {
  final String message;
  const VehicleDeleteError(this.message);
}