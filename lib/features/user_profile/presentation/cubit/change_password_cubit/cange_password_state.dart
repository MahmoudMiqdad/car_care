import 'package:car_care/features/user_profile/domain/entities/profile_entity.dart' show ProfileEntity;

abstract class PasswordState {
  const PasswordState();
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordSuccess extends PasswordState {
  final ProfileEntity profile;

  const PasswordSuccess(this.profile);
}

class PasswordError extends PasswordState {
  final String message;

  const PasswordError(this.message);
}