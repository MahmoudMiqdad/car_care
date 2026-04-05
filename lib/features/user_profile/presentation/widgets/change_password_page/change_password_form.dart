import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/user_profile/presentation/cubit/change_password_cubit/cange_password_state.dart';
import 'package:car_care/features/user_profile/presentation/cubit/change_password_cubit/change_password_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPassword.dispose(); 
    super.dispose();
  }

  Future<void> _submit() async {
    context.read<PasswordCubit>().updatePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPassword.text,
    );
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      final strings = context.l10n;
    return BlocConsumer<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if (state is PasswordSuccess) {
          _showSnack(context, strings.changedpasswordsuccessfully);
        } else if (state is PasswordError) {
          _showSnack(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is PasswordLoading;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  LoginTextField(
                    controller: _currentPasswordController,
                    hintText: strings.currentPassword,
                    icon: IconsaxPlusLinear.lock_1,
                    isPassword: true,
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: _newPasswordController,
                    hintText: strings.newPassword,
                    icon: IconsaxPlusLinear.lock_1,
                    isPassword: true,
                  ),
                  SizedBox(height: 16.h),
                  LoginTextField(
                    controller: _confirmPassword,
                    hintText: strings.confirmPassword,
                    icon: IconsaxPlusLinear.lock_1,
                    isPassword: true,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    height: AppConstants.buttonHeight.h,
                    child: AppButton(
                      onPressed: isLoading ? null : _submit,
                      text: strings.editPassword,
                      backgroundColor: AppColors.orange,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(child: AppLoadingWidget()),
              ),
          ],
        );
      },
    );
  }
}