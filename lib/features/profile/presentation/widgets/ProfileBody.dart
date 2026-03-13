
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/profile/presentation/widgets/ProfileActionButton.dart';
import 'package:car_care/features/profile/presentation/widgets/ProfileAvatar.dart';
import 'package:car_care/features/profile/presentation/widgets/ProfileInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileAvatar(),
            SizedBox(height: 8.h),
            Text(
              'شدن العلي',
              style: TextStyle(
                fontSize: 27.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30.h),
            const ProfileInfoCard(
              title: 'رقم الهاتف',
              value: '0987654321',
              icon: Icons.phone_in_talk_outlined,
            ),
            SizedBox(height: 16.h),
            const ProfileInfoCard(
              title: 'البريد الإلكتروني',
              value: 'shadanali@gmail.com',
              icon: Icons.email_outlined,
            ),
            SizedBox(height: 30.h),
            ProfileActionButton(
              text: 'تعديل الملف الشخصي',
              backgroundColor: AppColors.orange,
              textColor: Colors.white,
              onPressed: () {},
            ),
            SizedBox(height: 16.h),
            ProfileActionButton(
              text: 'تعديل كلمة المرور',
              backgroundColor: AppColors.orange,
              textColor: Colors.white,
              onPressed: () {},
            ),
            SizedBox(height: 16.h),
            ProfileActionButton(
              text: 'حذف الحساب',
              backgroundColor: Colors.white,
              textColor: const Color(0xFFA12323),
              borderColor: const Color(0xFFA12323),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}