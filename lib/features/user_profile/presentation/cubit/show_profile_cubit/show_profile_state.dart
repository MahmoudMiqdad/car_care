

import 'package:car_care/features/user_profile/domain/entities/profile_entity.dart';

abstract class ShowProfileState {
  const ShowProfileState();
}

class ShowProfileInitial extends ShowProfileState {}

class ShowProfileLoading extends ShowProfileState {}

class ShowProfileLoaded extends ShowProfileState {
  final ProfileEntity profile;

  const ShowProfileLoaded(this.profile);
}

class ShowProfileError extends ShowProfileState {
  final String message;

  const ShowProfileError(this.message);
}