import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/update_profile_cubit/update_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this._repository)
      : super(UpdateProfileInitial());

  final IProfileRepository _repository;

  Future<void> updateProfile(Map<String, dynamic> params) async {
    emit(UpdateProfileLoading());

    final result = await _repository.updateprofile(params);

    result.fold(
      (failure) => emit(UpdateProfileError(failure.message)),
      (profile) => emit(UpdateProfileSuccess(profile)),
    );
  }
}