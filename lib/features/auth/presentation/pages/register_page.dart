import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_state.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/features/auth/presentation/widgets/register/register_content.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocProvider(
      create: (_) => AuthBloc(getIt<IAuthRepository>()),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
                AppSnackBar.error(context, state.message);
            } else if (state is AuthSuccess) {
               AppSnackBar.success(context,strings.registrationSuccess);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GoRouter.of(context).go(Routes.login);
              });
            }
          },
          builder: (context, state) {
            bool isLoading = false;

            if (state is AuthFormState) {
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.backgroung, fit: BoxFit.cover),
                SafeArea(
                  child: Column(
                    children: [
                      LoginHeader(),
                      Expanded(
                        child: RegisterContent(
                          phoneController: _phoneController,
                          formKey: _formKey,
                          firstNameController: _nameController,
                          accountController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isLoading: isLoading,
                          onRegister: () => context
                              .read<AuthBloc>()
                              .add(SubmitRegister()),
                          onGoToLogin: () {
                            GoRouter.of(context).go(Routes.login);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}