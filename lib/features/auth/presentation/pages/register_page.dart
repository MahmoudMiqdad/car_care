import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/auth/domain/repositories/abstract/i_auth_repository.dart';

import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_state.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/features/auth/presentation/widgets/register/register_content.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(getIt<IAuthRepository>()),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                GoRouter.of(context).go('/login');
              });
            }
          },
          builder: (context, state) {
            bool isLoading = false;
            bool isValid = true;

            if (state is AuthFormState) {
              isValid = state.isValid;
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/BK_.png', fit: BoxFit.cover),
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
                          onRegister: (isValid && !isLoading)
                              ? () => context.read<AuthBloc>().add(
                                  SubmitRegister(),
                                )
                              : null,
                          onGoToLogin: () => Navigator.pop(context),
                          isLoading: isLoading,
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
