// ignore_for_file: file_names

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileSetupForm extends StatefulWidget {
  const ProfileSetupForm({super.key});

  @override
  State<ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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
          controller: _nameController,
          hintText: 'الاسم الكامل',
          icon: IconsaxPlusLinear.user, 
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),

        LoginTextField(
          controller: _phoneController,
          hintText: 'رقم الهاتف',
          icon: IconsaxPlusLinear.call, 
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),

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
            onPressed: () {
            },
            text: 'حفظ و متابعة',
            backgroundColor: AppColors.orange,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}