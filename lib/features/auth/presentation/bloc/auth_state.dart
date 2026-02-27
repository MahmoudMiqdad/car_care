abstract class AuthState {}

class AuthFormState extends AuthState {
   final String phone;
  final String email;
  final String password;
  final String? name;
  final String? confirmPassword;
  final bool isValid;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final String? nameError;
  final String? confirmPasswordError;

  AuthFormState({
    required this.email,
    required this.password,
    this.name,
    this.confirmPassword,
    required this.isValid,
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.nameError,
    this.confirmPasswordError,
    required this.phone,
  });

  AuthFormState copyWith({
    String? email,
    String? phone,
    String? password,
    String? name,
    String? confirmPassword,
    bool? isValid,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? nameError,
    String? confirmPasswordError,
  }) {
    return AuthFormState(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      nameError: nameError,
      confirmPasswordError: confirmPasswordError,
    );
  }
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}