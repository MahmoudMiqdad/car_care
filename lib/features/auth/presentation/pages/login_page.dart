import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_state.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_content.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
      final strings = context.l10n;
    final accountController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => AuthBloc(getIt<IAuthRepository>()),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(strings.loginSuccess)),
              );
              GoRouter.of(context).go(Routes.home);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            bool isLoading = false;
            bool isValid = false;

            if (state is AuthFormState) {
              isValid = state.isValid;
            }

            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/BK_.png', fit: BoxFit.cover),
                  SafeArea(
                    child: Column(
                      children: [
                        const LoginHeader(),
                        Expanded(
                          child: LoginContent(
                            formKey: formKey,
                            accountController: accountController,
                            passwordController: passwordController,
                            onLogin: (isValid && !isLoading)
                                ? () => context.read<AuthBloc>().add(
                                      SubmitLogin(),
                                    )
                                : null,
                            onForgotPassword: null,
                            onRegister: () {
                              GoRouter.of(context).go(Routes.signup);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
