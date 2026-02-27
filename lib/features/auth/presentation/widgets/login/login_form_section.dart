import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'login_text_field.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({
    super.key,
    required this.accountController,
    required this.passwordController,

    this.onForgotPassword,
   required this.onRegister, VoidCallback? onLogin, 
  }) : _onLogin = onLogin;

  final TextEditingController accountController;
  final TextEditingController passwordController;
  final VoidCallback? _onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;


  @override
  Widget build(BuildContext context) {
      final strings = context.l10n;
    final theme = Theme.of(context);
     
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
    LoginTextField(
  controller: accountController,
  hintText: context.l10n.email,
  keyboardType: TextInputType.text,
  icon: IconsaxPlusLinear.user,

  validator: (_) => null,
  onChanged: (value) {
    context.read<AuthBloc>().add(EmailChanged(value));
  },
),
        SizedBox(height: 16.h),
      LoginTextField(
  controller: passwordController,
  hintText: context.l10n.password,
  isPassword: true,
  keyboardType: TextInputType.visiblePassword,
  icon: IconsaxPlusLinear.lock_1,

  validator: (_) => null,
  onChanged: (value) {
    context.read<AuthBloc>().add(PasswordChanged(value));
  },
),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: onForgotPassword,
            child: Text(
              'نسيت كلمة المرور',
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
          
            onPressed: _onLogin,
            text: 'تسجيل الدخول',
            backgroundColor: AppColors.orange,
            textColor: AppColors.white,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ليس لديك حساب؟ ',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightPrimary,
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: onRegister,
              child: Text(
                'إنشاء حساب',
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
