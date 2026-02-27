import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:car_care/features/auth/presentation/bloc/auth_event.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.accountController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onRegister,
    required this.onGoToLogin,
    this.isLoading = false, VoidCallback? onregister, required this.phoneController,
  }) : _onregister = onregister;

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController accountController;
  final TextEditingController passwordController;
   final TextEditingController phoneController;
  final TextEditingController confirmPasswordController;
final VoidCallback? _onregister;
  final VoidCallback? onRegister;
  final VoidCallback onGoToLogin;
  final bool isLoading;

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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginTextField(
                    controller: firstNameController,
                    hintText: 'الاسم الأول',
                    keyboardType: TextInputType.name,
                    icon: IconsaxPlusLinear.user,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أدخل الاسم الأول';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      context.read<AuthBloc>().add(NameChanged(value));
                    },
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: accountController,
                    hintText: 'البريد الإلكتروني أو رقم الهاتف',
                    keyboardType: TextInputType.emailAddress,
                    icon: IconsaxPlusLinear.sms,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أدخل البريد الإلكتروني أو رقم الهاتف';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      context.read<AuthBloc>().add(EmailChanged(value));
                    },
                  ),  SizedBox(height: 16.h),
                    LoginTextField(
                    controller: phoneController,
                    hintText: 'رقم الهاتف',
                    isPassword: false,
                    keyboardType: TextInputType.visiblePassword,
                    icon: IconsaxPlusLinear.lock_1,
                  

                    onChanged: (value) {
                      context.read<AuthBloc>().add(
                        PhoneChanged(value),
                      );
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
                      if (v.trim().length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }

                      return null;
                    },

                    onChanged: (value) {
                      context.read<AuthBloc>().add(PasswordChanged(value));
                    },
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: confirmPasswordController,
                    hintText: 'تأكيد كلمة المرور',
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    icon: IconsaxPlusLinear.lock_1,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'أعد إدخال كلمة المرور';
                      }
                      if (v.trim() != passwordController.text.trim()) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      context.read<AuthBloc>().add(
                        ConfirmPasswordChanged(value),
                      );
                    },
                  ),
                  SizedBox(height: 45.h),
                  SizedBox(
                    height: AppConstants.buttonHeight.h,
                    child: AppButton(
                      onPressed: isLoading ? null : onRegister,
                      text: isLoading ? 'جاري الإنشاء...' : 'إنشاء حساب',
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
                        onTap: _onregister,
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
          'We’re here to keep your car in top shape. Are you ready?',
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
