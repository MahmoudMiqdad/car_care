abstract class AvailabilityState {
  const AvailabilityState();
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

class AvailabilitySuccess extends AvailabilityState {
  const AvailabilitySuccess(this.isAvailable);
  final bool isAvailable;
}

class AvailabilityError extends AvailabilityState {
  const AvailabilityError(this.message);
  final String message;
}
