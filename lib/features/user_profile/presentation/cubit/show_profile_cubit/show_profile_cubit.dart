import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ShowProfileCubit extends Cubit<ShowProfileState> {
  ShowProfileCubit(this._repository) : super(ShowProfileInitial());

  final IProfileRepository _repository;

  Future<void> getProfile() async {
    emit(ShowProfileLoading());

    final result = await _repository.showprofile();

    result.fold(
      (failure) => emit(ShowProfileError(failure.message)),
      (profile) => emit(ShowProfileLoaded(profile)),
    );
  }
}