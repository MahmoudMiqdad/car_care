import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/features/auth/presentation/widgets/reset_password/reset_password_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: BlocProvider(
        create: (_) => getIt<PasswordResetCubit>()
          ..seedVerified(email: email, resetToken: resetToken),
        child: Builder(
          builder: (context) {
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
                          child: ResetPasswordContent(
                            onSuccess: (message) {
                              AppSnackBar.success(context, message);
                              context.go(Routes.login);
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
