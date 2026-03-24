import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginTextField(
          controller: _currentPasswordController,
          hintText: 'كلمة المرور الحالية',
          icon: IconsaxPlusLinear.lock_1,
          isPassword: true,
        ),
        SizedBox(height: 16.h),
        LoginTextField(
          controller: _newPasswordController,
          hintText: 'كلمة المرور الجديدة',
          icon: IconsaxPlusLinear.lock_1,
          isPassword: true,
        ),
        SizedBox(height: 40.h),
        SizedBox(
          height: AppConstants.buttonHeight.h,
          child: AppButton(
            onPressed: () {},
            text: 'تعديل كلمة المرور',
            backgroundColor: AppColors.orange,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}