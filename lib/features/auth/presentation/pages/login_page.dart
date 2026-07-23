import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
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
  // Multi-provider accounts: every user is a customer, so login always
  // lands on Home. Provider flows are reached from the More page.
  void _navigateHome(BuildContext context) {
    GoRouter.of(context).go(Routes.home);
  }

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
              AppSnackBar.success(context, strings.loginSuccess);
              _navigateHome(context);
            } else if (state is AuthFailure) {
             AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {

            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.backgroung, fit: BoxFit.cover),
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