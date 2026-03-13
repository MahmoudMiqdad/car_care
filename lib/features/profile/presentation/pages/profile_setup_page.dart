import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_header.dart';
import 'package:car_care/features/profile/presentation/widgets/ProfileSetupContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
        Image.asset('assets/images/BK_.png', fit: BoxFit.cover),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const LoginHeader(),
                SizedBox(height: 16.h),
                const Expanded(
                  child: ProfileSetupContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
