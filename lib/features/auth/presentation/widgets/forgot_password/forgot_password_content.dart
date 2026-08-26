import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:car_care/features/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class ForgotPasswordContent extends StatefulWidget {
  const ForgotPasswordContent({super.key});

  @override
  State<ForgotPasswordContent> createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<ForgotPasswordContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
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
            Text(
              strings.forgotPasswordTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 26.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 32.h),
            Form(
              key: _formKey,
              child: LoginTextField(
                innerBorderColor: Colors.transparent,
                controller: _emailController,
                hintText: strings.enterYourEmailHint,
                keyboardType: TextInputType.emailAddress,
                icon: IconsaxPlusLinear.sms,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return strings.enterEmail;
                  if (!_emailPattern.hasMatch(value)) {
                    return strings.invalidEmail;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 28.h),
            BlocBuilder<PasswordResetCubit, PasswordResetState>(
              builder: (context, state) {
                final isLoading = state.phase == PasswordResetPhase.sendingOtp;
                return SizedBox(
                  height: AppConstants.buttonHeight.h,
                  child: AppButton(
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<PasswordResetCubit>().sendOtp(
                          _emailController.text.trim(),
                        );
                      }
                    },
                    text: strings.sendVerificationCode,
           outlineSurfaceColor: AppColors.white,
                    textColor: AppColors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
