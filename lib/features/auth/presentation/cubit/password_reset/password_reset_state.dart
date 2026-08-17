enum PasswordResetPhase {
  initial,
  sendingOtp,
  otpSent,
  verifyingOtp,
  otpVerified,
  resettingPassword,
  success,
}

class PasswordResetState {
  final PasswordResetPhase phase;
  final String email;
  final String? resetToken;
  final bool isResending;
  final String? message;
  final bool isError;

  const PasswordResetState({
    this.phase = PasswordResetPhase.initial,
    this.email = '',
    this.resetToken,
    this.isResending = false,
    this.message,
    this.isError = false,
  });
}
