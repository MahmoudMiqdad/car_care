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
        // 1. حقل الاسم
        LoginTextField(
          controller: _nameController,
          hintText: 'الاسم الكامل',
          icon: IconsaxPlusLinear.user, // استخدام أيقوناتك
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),

        // 2. حقل رقم الهاتف
        LoginTextField(
          controller: _phoneController,
          hintText: 'رقم الهاتف',
          icon: IconsaxPlusLinear.call, // استخدام أيقوناتك
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),

        // 3. حقل كلمة المرور الحالية
        LoginTextField(
          controller: _currentPasswordController,
          hintText: 'كلمة المرور الحالية',
          icon: IconsaxPlusLinear.lock_1, // استخدام أيقوناتك
          isPassword: true,
        ),
        SizedBox(height: 16.h),

        // 4. حقل كلمة المرور الجديدة
        LoginTextField(
          controller: _newPasswordController,
          hintText: 'كلمة المرور الجديدة',
          icon: IconsaxPlusLinear.lock_1,
          isPassword: true,
        ),
        
        SizedBox(height: 40.h),

        // 5. زر الحفظ
        SizedBox(
          height: AppConstants.buttonHeight.h,
          child: AppButton(
            onPressed: () {
              // كود الحفظ هنا
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