// ignore_for_file: file_names
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileSetupForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfileSetupContent extends StatelessWidget {
  const ProfileSetupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile Setup',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 22.h),              
              const ProfileAvatar(),
              SizedBox(height: 40.h),
              const ProfileSetupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
