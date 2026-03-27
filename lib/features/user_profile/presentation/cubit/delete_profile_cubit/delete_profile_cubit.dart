import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/delete_profile_cubit/delete_profile_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteProfileCubit extends Cubit<DeleteProfileState> {
  DeleteProfileCubit(this._repository)
      : super(DeleteProfileInitial());

  final IProfileRepository _repository;

  Future<void> deleteProfile(String password) async {
    emit(DeleteProfileLoading());

    final result = await _repository.deletprofile(password);

    result.fold(
      (failure) => emit(DeleteProfileError(failure.message)),
      (_) => emit(DeleteProfileSuccess()),
    );
  }
}