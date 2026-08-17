import 'package:car_care/core/constants/app_constants.dart';
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

class ResetPasswordContent extends StatefulWidget {
  const ResetPasswordContent({super.key, required this.onSuccess});

  final void Function(String message) onSuccess;

  @override
  State<ResetPasswordContent> createState() => _ResetPasswordContentState();
}

class _ResetPasswordContentState extends State<ResetPasswordContent> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

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
        child: BlocConsumer<PasswordResetCubit, PasswordResetState>(
          listenWhen: (prev, curr) => prev.phase != curr.phase,
          listener: (context, state) {
            if (state.phase == PasswordResetPhase.success) {
              widget.onSuccess(
                state.message ?? strings.passwordChangedSuccessfully,
              );
            }
          },
          builder: (context, state) {
            final isLoading =
                state.phase == PasswordResetPhase.resettingPassword;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.resetPasswordTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 26.sp,
                        fontFamily: 'Poppins',
                      ),
                ),
                SizedBox(height: 32.h),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginTextField(
                        innerBorderColor: Colors.transparent,
                        controller: _passwordController,
                        hintText: strings.newPassword,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        icon: IconsaxPlusLinear.lock_1,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return strings.enterPassword;
                          if (value.length < 6) {
                            return strings.passwordMinLength;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      LoginTextField(
                        innerBorderColor: Colors.transparent,
                        controller: _confirmController,
                        hintText: strings.confirmPassword,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        icon: IconsaxPlusLinear.lock_1,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return strings.reEnterPassword;
                          if (value != _passwordController.text.trim()) {
                            return strings.thepasswordsdonotmatch;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),
                SizedBox(
                  height: AppConstants.buttonHeight.h,
                  child: AppButton(
                    isLoading: isLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<PasswordResetCubit>().resetPassword(
                              password: _passwordController.text.trim(),
                              passwordConfirmation:
                                  _confirmController.text.trim(),
                            );
                      }
                    },
                    text: strings.resetPasswordButton,
                    backgroundColor: AppColors.orange,
                    textColor: AppColors.white,
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
