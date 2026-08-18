import 'package:car_care/features/auth/data/services/google_sign_in_service.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository repo;
  final GoogleSignInService? _googleSignInService;

  AuthBloc(this.repo, {GoogleSignInService? googleSignInService})
      : _googleSignInService = googleSignInService,
        super(AuthFormState(email: "", password: "", isValid: false, phone: '')) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
     on<PhoneChanged>(_phoneChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SubmitLogin>(_onSubmitLogin);
    on<SubmitRegister>(_onSubmitRegister);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  void _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    final email = event.email.trim();
    final isValid = _checkFormValidity(s.copyWith(email: email));
    emit(s.copyWith(email: email, isValid: isValid));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    final password = event.password.trim();
    final isValid = _checkFormValidity(s.copyWith(password: password));
    emit(s.copyWith(password: password, isValid: isValid));
  }

  void _onNameChanged(NameChanged event, Emitter<AuthState> emit) {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    final name = event.name.trim();
    final isValid = _checkFormValidity(s.copyWith(name: name));
    emit(s.copyWith(name: name, isValid: isValid));
  }
  void _phoneChanged(PhoneChanged event, Emitter<AuthState> emit) {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    final phone = event.phone.trim();
    final isValid = _checkFormValidity(s.copyWith(phone: phone));
    emit(s.copyWith(phone: phone, isValid: isValid));
  }
  void _onConfirmPasswordChanged(
      ConfirmPasswordChanged event, Emitter<AuthState> emit) {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    final confirmPassword = event.confirmPassword.trim();
    final isValid = _checkFormValidity(
        s.copyWith(confirmPassword: confirmPassword));
    emit(s.copyWith(confirmPassword: confirmPassword, isValid: isValid));
  }

  Future<void> _onSubmitLogin(
      SubmitLogin event, Emitter<AuthState> emit) async {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    emit(s.copyWith(isLoading: true));
    final response = await repo.login(s.email, s.password);
    response.fold(
      (error) {
        emit(AuthFailure(error.message));
        emit(s.copyWith(isLoading: false));
      },
      (user) {
        emit(AuthSuccess());
      },
    );
  }

  Future<void> _onSubmitRegister(
      SubmitRegister event, Emitter<AuthState> emit) async {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;
    emit(s.copyWith(isLoading: true));
    final response = await repo.register({
      'name': s.name ?? '',
      'email': s.email,
         'phone': s.phone,
      'password': s.password,
       'password_confirmation': s.confirmPassword,
    });
    response.fold(
      (error) {
        emit(AuthFailure(error.message));
        emit(s.copyWith(isLoading: false));
      },
      (user) {
        emit(AuthSuccess());
      },
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthFormState) return;
    final s = state as AuthFormState;

    final service = _googleSignInService;
    if (service == null) {
      emit(AuthFailure('خدمة تسجيل الدخول عبر Google غير مهيأة'));
      emit(s.copyWith(isLoading: false));
      return;
    }

    String? idToken;
    try {
      idToken = await service.signInAndGetIdToken();
    } on GoogleIdTokenMissingException {
      emit(AuthFailure('تعذر الحصول على بيانات الدخول من Google'));
      emit(s.copyWith(isLoading: false));
      return;
    } on GoogleSignInException {
      emit(AuthFailure('تعذر تسجيل الدخول عبر Google، تحقق من الإعدادات'));
      emit(s.copyWith(isLoading: false));
      return;
    } catch (_) {
      emit(AuthFailure('حدث خطأ غير متوقع أثناء تسجيل الدخول عبر Google'));
      emit(s.copyWith(isLoading: false));
      return;
    }

    if (idToken == null) {
      return;
    }

    emit(s.copyWith(isLoading: true));
    final response = await repo.loginWithGoogle(idToken);
    response.fold(
      (error) {
        emit(AuthFailure(error.displayMessage));
        emit(s.copyWith(isLoading: false));
      },
      (user) {
        emit(AuthSuccess());
      },
    );
  }

  bool _checkFormValidity(AuthFormState state) {
    // login validation
    if (state.name == null || state.name!.isEmpty) {
      return state.email.contains("@") && state.password.length >= 6;
    } else {
      // register validation
      return state.name!.isNotEmpty &&
          state.email.contains("@") &&
          state.password.length >= 6 &&
          state.password == (state.confirmPassword ?? '');
    }
  }
}