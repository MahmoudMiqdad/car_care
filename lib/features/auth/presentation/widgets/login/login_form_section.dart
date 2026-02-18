import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'login_text_field.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({
    super.key,
    required this.accountController,
    required this.passwordController,
    required this.onLogin,
    this.onForgotPassword,
    this.onRegister,
  });

  final TextEditingController accountController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginTextField(
          controller: accountController,
          hintText: 'الحساب أو رقم الهاتف',
          keyboardType: TextInputType.text,
          icon: IconsaxPlusLinear.user,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'أدخل الحساب أو رقم الهاتف';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        LoginTextField(
          controller: passwordController,
          hintText: 'كلمة المرور',
          isPassword: true,
          keyboardType: TextInputType.visiblePassword,
          icon: IconsaxPlusLinear.lock_1,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'أدخل كلمة المرور';
            }
            return null;
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
            onPressed: onLogin,
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
