import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AvatarCubit extends Cubit<AvatarState> {
  AvatarCubit(this._repository) : super(AvatarInitial());

  final IProfileRepository _repository;

  Future<void> updateAvatar( { XFile? avatar}) async {
    emit(AvatarLoading());

    final result = await _repository.updateavatar(avatar);

    result.fold(
      (failure) => emit(AvatarError(failure.message)),
      (profile) => emit(AvatarUpdated(profile)),
    );
  }

  Future<void> deleteAvatar() async {
    emit(AvatarLoading());

    final result = await _repository.deletavatar();

    result.fold(
      (failure) => emit(AvatarError(failure.message)),
      (profile) => emit(AvatarDeleted(profile)),
    );
  }
}