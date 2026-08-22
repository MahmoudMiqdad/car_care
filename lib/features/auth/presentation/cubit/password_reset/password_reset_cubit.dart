import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._repository) : super(const PasswordResetState());

  final IAuthRepository _repository;

  // Used by ResetPasswordPage, which gets a fresh cubit instance and needs
  // the email/reset_token carried over from the OTP verification step.
  void seedVerified({required String email, required String resetToken}) {
    emit(
      PasswordResetState(
        phase: PasswordResetPhase.otpVerified,
        email: email,
        resetToken: resetToken,
      ),
    );
  }

  Future<void> sendOtp(String email) async {
    emit(
      PasswordResetState(phase: PasswordResetPhase.sendingOtp, email: email),
    );

    final result = await _repository.requestPasswordReset(email);
    result.fold(
      (failure) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.initial,
          email: email,
          message: failure.displayMessage,
          isError: true,
        ),
      ),
      (message) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.otpSent,
          email: email,
          message: message,
        ),
      ),
    );
  }

  Future<void> resendOtp() async {
    emit(
      PasswordResetState(
        phase: state.phase,
        email: state.email,
        resetToken: state.resetToken,
        isResending: true,
      ),
    );

    final result = await _repository.requestPasswordReset(state.email);
    result.fold(
      (failure) => emit(
        PasswordResetState(
          phase: state.phase,
          email: state.email,
          message: failure.displayMessage,
          isError: true,
        ),
      ),
      (message) => emit(
        PasswordResetState(
          phase: state.phase,
          email: state.email,
          message: message,
        ),
      ),
    );
  }

  Future<void> verifyOtp(String otp) async {
    emit(
      PasswordResetState(
        phase: PasswordResetPhase.verifyingOtp,
        email: state.email,
      ),
    );

    final result = await _repository.verifyResetOtp(
      email: state.email,
      otp: otp,
    );
    result.fold(
      (failure) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.otpSent,
          email: state.email,
          message: failure.displayMessage,
          isError: true,
        ),
      ),
      (data) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.otpVerified,
          email: state.email,
          resetToken: data.resetToken,
        ),
      ),
    );
  }

  Future<void> resetPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(
      PasswordResetState(
        phase: PasswordResetPhase.resettingPassword,
        email: state.email,
        resetToken: state.resetToken,
      ),
    );

    final result = await _repository.resetPassword(
      email: state.email,
      resetToken: state.resetToken ?? '',
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    result.fold(
      (failure) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.otpVerified,
          email: state.email,
          resetToken: state.resetToken,
          message: failure.displayMessage,
          isError: true,
        ),
      ),
      (message) => emit(
        PasswordResetState(
          phase: PasswordResetPhase.success,
          email: state.email,
          message: message,
        ),
      ),
    );
  }
}
