import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_form_section.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController accountController,
    required TextEditingController passwordController,
    VoidCallback? onLogin,
    VoidCallback? onForgotPassword,
    VoidCallback? onRegister,
  })  : _formKey = formKey,
        _accountController = accountController,
        _passwordController = passwordController,
        _onLogin = onLogin,
        _onForgotPassword = onForgotPassword,
        _onRegister = onRegister;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _accountController;
  final TextEditingController _passwordController;

 final VoidCallback? _onLogin;
  final VoidCallback? _onForgotPassword;
  final VoidCallback? _onRegister;

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
            const _LoginTitle(),
            SizedBox(height: 16.h),
            const _LoginImage(),
            SizedBox(height: 24.h),
            Form(
              key: _formKey,
              child: LoginFormSection(
                accountController: _accountController,
                passwordController: _passwordController,
                onLogin: _onLogin,
                onForgotPassword: _onForgotPassword,
                onRegister: _onRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 4.h),
        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
                letterSpacing: 0.4,
                height: 1.25,
                fontFamily: 'Poppins',
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Ready to get back on the road?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.lightPrimary,
                fontSize: 17.sp,
                height: 1.35,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
        ),
      ],
    );
  }
}

class _LoginImage extends StatelessWidget {
  const _LoginImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          'assets/images/City driver-pana.png',
          height: 200.h,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.car_repair,
              size: 80.sp,
              color: AppColors.info,
            ),
          ),
        ),
      ),
    );
  }
}
