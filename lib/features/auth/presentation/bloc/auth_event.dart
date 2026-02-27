abstract class AuthEvent {}

class EmailChanged extends AuthEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends AuthEvent {
  final String password;
  PasswordChanged(this.password);
}

class NameChanged extends AuthEvent {
  final String name;
  NameChanged(this.name);
}

class ConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class   PhoneChanged extends AuthEvent {
  final String phone;
  PhoneChanged(this.phone);
}
class SubmitLogin extends AuthEvent {}

class SubmitRegister extends AuthEvent {}

class ForceLogout extends AuthEvent {}