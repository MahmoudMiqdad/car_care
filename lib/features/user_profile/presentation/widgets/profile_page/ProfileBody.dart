// ignore: file_names
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';

import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileInfoCard.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});
  @override
  Widget build(BuildContext context) {
     final strings = context.l10n;

    return BlocBuilder<ShowProfileCubit, ShowProfileState>(
      builder: (context, state) {
        // loading
        if (state is ShowProfileLoading) {
          return const Center(child: AppLoadingWidget());
        }
        //  error
        if (state is ShowProfileError) {
          return Center(child: Text(state.message));
        }
        //  success
        if (state is ShowProfileLoaded) {
          final profile = state.profile;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
             GestureDetector(
  onTap: () {
    if (profile.avatar != null && profile.avatar!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: Image.network(
              profile.avatar!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
  },
  child: CircleAvatar(
    radius: 60.r,
    backgroundColor: Colors.grey.shade300,
    backgroundImage: profile.avatar != null && profile.avatar!.isNotEmpty
        ? NetworkImage(profile.avatar!)
        : null,
    child: (profile.avatar == null || profile.avatar!.isEmpty)
        ? Icon(Icons.person, size: 100.sp, color: Colors.grey.shade400)
        : null,
  ),
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
                    title: strings.phoneNumber,
                    value: profile.phone,
                    icon: Icons.phone_in_talk_outlined,
                  ),
                  SizedBox(height: 16.h),
                  ProfileInfoCard(
                    title: strings.email,
                    value: profile.email,
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 30.h),
                  AppButton(
                    text: strings.editProfile,
                    backgroundColor: AppColors.orange,
                    onPressed: () => context.push(Routes.profile_setup),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: strings.editPassword,
                    backgroundColor: AppColors.orange,
                    onPressed: () => context.push(Routes.changepasswordpage),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: strings.delete,
                    isOutline: true,
                    backgroundColor: const Color(0xFFA12323),
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
