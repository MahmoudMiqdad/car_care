import 'package:car_care/features/user_profile/domain/entities/profile_entity.dart';

abstract class UpdateProfileState {
  const UpdateProfileState();
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final ProfileEntity profile;

  const UpdateProfileSuccess(this.profile);
}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  const UpdateProfileError(this.message);
}