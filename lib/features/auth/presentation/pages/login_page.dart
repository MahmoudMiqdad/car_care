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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                SnackBar(
                  content: Text(strings.loginSuccess),
                  backgroundColor: Colors.green,
                ),
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
            bool isLoading = state is AuthLoading;

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
                            onLogin: () => context.read<AuthBloc>().add(
                                  SubmitLogin(),
                                ),
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