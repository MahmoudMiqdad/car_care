import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/change_password_cubit/cange_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit(this._repository) : super(PasswordInitial());

  final IProfileRepository _repository;

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {

   
    if (currentPassword.trim().isEmpty ||
        newPassword.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      emit(PasswordError('الرجاء تعبئة جميع الحقول'));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(PasswordError('كلمتا المرور غير متطابقتين'));
      return;
    }

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