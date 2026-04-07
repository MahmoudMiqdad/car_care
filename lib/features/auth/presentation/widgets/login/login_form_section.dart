import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'login_text_field.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection( {
    super.key,
    required this.accountController,
    required this.passwordController,
    this.onForgotPassword,
    required this.onRegister,
    VoidCallback? onLogin, required this.formKey,
  }) : _onLogin = onLogin;

  final TextEditingController accountController;
  final TextEditingController passwordController;
  final VoidCallback? _onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;
final GlobalKey<FormState> formKey;
  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
    bool submitted = false; 
  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginTextField(
          controller: widget.accountController,
          hintText: strings.email,
          keyboardType: TextInputType.emailAddress,
          icon: IconsaxPlusLinear.sms,
         validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return strings.enterEmail;
                      }
                      return null;
                    },
          onChanged: (value) {
            context.read<AuthBloc>().add(EmailChanged(value));
          },
        ),
        SizedBox(height: 16.h),
        LoginTextField(
          controller: widget.passwordController,
          hintText: strings.password,
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
          icon: IconsaxPlusLinear.lock_1,
           validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return strings.enterPassword;
                      }
                      if (v.trim().length < 6) {
                        return strings.passwordMinLength;
                      }
                      return null;
                    },
          onChanged: (value) {
            context.read<AuthBloc>().add(PasswordChanged(value));
          },
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: widget.onForgotPassword,
            child: Text(
              strings.forgotPassword,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.lightPrimary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          height: AppConstants.buttonHeight.h,
          child: AppButton(
            onPressed:(){  setState(() => submitted = true);
                        if (widget.formKey.currentState?.validate() ?? false) {
                          widget._onLogin?.call();
                        }},
            text: strings.login,
            backgroundColor: AppColors.orange,
            textColor: AppColors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              strings.dontHaveAccount,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightPrimary,
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: widget.onRegister,
              child: Text(
                strings.createAccount,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}