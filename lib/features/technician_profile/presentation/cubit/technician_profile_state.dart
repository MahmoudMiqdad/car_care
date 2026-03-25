import '../../domain/entities/technician_profile_entity.dart';

abstract class TechnicianProfileState {
  const TechnicianProfileState();
}

class TechnicianProfileInitial extends TechnicianProfileState {}

class TechnicianProfileLoading extends TechnicianProfileState {}

class TechnicianProfileLoaded extends TechnicianProfileState {
  final TechnicianProfileEntity profile;

  const TechnicianProfileLoaded(this.profile);
}

class TechnicianProfileError extends TechnicianProfileState {
  final String message;

  const TechnicianProfileError(this.message);
}