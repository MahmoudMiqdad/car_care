import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController accountController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required VoidCallback onRegister,
    required VoidCallback onGoToLogin,
  })  : _formKey = formKey,
        _firstNameController = firstNameController,
        _accountController = accountController,
        _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController,
        _onRegister = onRegister,
        _onGoToLogin = onGoToLogin;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _firstNameController;
  final TextEditingController _accountController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;

  final VoidCallback _onRegister;
  final VoidCallback _onGoToLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 36.h, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _RegisterTitle(),
            SizedBox(height: 24.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginTextField(
                    controller: _firstNameController,
                    hintText: 'الاسم الأول',
                    keyboardType: TextInputType.name,
                    icon: IconsaxPlusLinear.user,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أدخل الاسم الأول';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: _accountController,
                    hintText: 'البريد الإلكتروني أو رقم الهاتف',
                    keyboardType: TextInputType.emailAddress,
                    icon: IconsaxPlusLinear.sms,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أدخل البريد الإلكتروني أو رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: _passwordController,
                    hintText: 'كلمة المرور',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    icon: IconsaxPlusLinear.lock_1,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أدخل كلمة المرور';
                      }
                      if (v.trim().length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: _confirmPasswordController,
                    hintText: 'تأكيد كلمة المرور',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    icon: IconsaxPlusLinear.lock_1,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أعد إدخال كلمة المرور';
                      }
                      if (v.trim() != _passwordController.text.trim()) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 45.h),
                  SizedBox(
                    height: AppConstants.buttonHeight.h,
                    child: AppButton(
                      onPressed: _onRegister,
                      text: 'إنشاء حساب',
                      backgroundColor: AppColors.orange,
                      textColor: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب؟ ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightPrimary,
                          fontSize: 16.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onGoToLogin,
                        child: Text(
                          'تسجيل الدخول',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterTitle extends StatelessWidget {
  const _RegisterTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 4.h),
        Text(
          'Create Your Account',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 26.sp,
                letterSpacing: 0.4,
                height: 1.25,
                fontFamily: 'Poppins',
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          'We’re here to keep your car in top shape.         Are you ready?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.lightPrimary,
                fontSize: 15.sp,
                height: 1.35,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
        ),
        SizedBox(height: 45.h),
      ],
    );
  }
}

