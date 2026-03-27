import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/change_password_cubit/cange_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit(this._repository) : super(PasswordInitial());

  final IProfileRepository _repository;

  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    emit(PasswordLoading());

    final result = await _repository.updatepassword(
      currentPassword,
      newPassword,
      confirmPassword,
    );

    result.fold(
      (failure) => emit(PasswordError(failure.message)),
      (profile) => emit(PasswordSuccess(profile)),
    );
  }
}