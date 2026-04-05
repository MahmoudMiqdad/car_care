import 'package:car_care/features/user_profile/domain/entities/Avatar_entity.dart';
import 'package:car_care/features/user_profile/domain/entities/profile_entity.dart';


abstract class AvatarState {
  const AvatarState();
}

class AvatarInitial extends AvatarState {}

class AvatarLoading extends AvatarState {}

class AvatarUpdated extends AvatarState {
  final AvatarEntity profile;

  const AvatarUpdated(this.profile);
}

class AvatarDeleted extends AvatarState {
  final ProfileEntity profile;

  const AvatarDeleted(this.profile);
}

class AvatarError extends AvatarState {
  final String message;

  const AvatarError(this.message);
}