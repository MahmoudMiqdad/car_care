

abstract class DeleteProfileState {
  const DeleteProfileState();
}

class DeleteProfileInitial extends DeleteProfileState {}

class DeleteProfileLoading extends DeleteProfileState {}

class DeleteProfileSuccess extends DeleteProfileState {}

class DeleteProfileError extends DeleteProfileState {
  final String message;

  const DeleteProfileError(this.message);
}