import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/forgot_password_content.dart';
import 'package:car_care/features/auth/presentation/widgets/forgot_password/otp_verification_card.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _otpDialogOpen = false;

  void _showOtpDialog(BuildContext context, PasswordResetCubit cubit) {
    _otpDialogOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const OtpVerificationCard(),
      ),
    ).then((_) => _otpDialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: BlocProvider(
        create: (_) => getIt<PasswordResetCubit>(),
        child: Builder(
          builder: (context) {
            final cubit = context.read<PasswordResetCubit>();

            return BlocListener<PasswordResetCubit, PasswordResetState>(
              listenWhen: (prev, curr) => prev.phase != curr.phase,
              listener: (context, state) {
                if (state.phase == PasswordResetPhase.otpSent &&
                    !_otpDialogOpen) {
                  _showOtpDialog(context, cubit);
                } else if (state.phase == PasswordResetPhase.otpVerified) {
                  if (_otpDialogOpen) {
                    Navigator.of(context, rootNavigator: true).pop();
                    _otpDialogOpen = false;
                  }
                  final email = state.email;
                  final resetToken = state.resetToken ?? '';
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      context.push(
                        Routes.resetPassword,
                        extra: {'email': email, 'resetToken': resetToken},
                      );
                    }
                  });
                } else if (state.isError && state.message != null) {
                  AppSnackBar.error(context, state.message!);
                }
              },
              child: Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(AppAssets.backgroung, fit: BoxFit.cover),
                    SafeArea(
                      child: Column(
                        children: [
                          const LoginHeader(),
                          const Expanded(child: ForgotPasswordContent()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
