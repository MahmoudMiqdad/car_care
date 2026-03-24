import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/profile/presentation/pages/change_passwordpage.dart';
import 'package:car_care/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:car_care/features/profile/presentation/widgets/profile_page/ProfileActionButton.dart';
import 'package:car_care/features/profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:car_care/features/profile/presentation/widgets/profile_page/ProfileInfoCard.dart';
import 'package:car_care/features/profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/profile/presentation/cubit/show_profile_cubit/show_profile_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowProfileCubit, ShowProfileState>(
      builder: (context, state) {
        // 🔹 loading
        if (state is ShowProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 🔹 error
        if (state is ShowProfileError) {
          return Center(child: Text(state.message));
        }

        // 🔹 success
        if (state is ShowProfileLoaded) {
          final profile = state.profile;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatar(
                    // imageUrl: profile.avatar,
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  ProfileInfoCard(
                    title: 'رقم الهاتف',
                    value: profile.phone,
                    icon: Icons.phone_in_talk_outlined,
                  ),

                  SizedBox(height: 16.h),

                  ProfileInfoCard(
                    title: 'البريد الإلكتروني',
                    value: profile.email,
                    icon: Icons.email_outlined,
                  ),

                  SizedBox(height: 30.h),

                  ProfileActionButton(
                    text: 'تعديل الملف الشخصي',
                    backgroundColor: AppColors.orange,
                    textColor: Colors.white,
                   onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSetupPage(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                 ProfileActionButton(
                    text: 'تعديل كلمة المرور',
                    backgroundColor: AppColors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
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

        return const SizedBox();
      },
    );
  }
}