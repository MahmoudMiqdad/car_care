// ignore_for_file: file_names
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/update_profile_cubit/update_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileSetupForm.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfileSetupContent extends StatelessWidget {
  const ProfileSetupContent({super.key, this.image});
  final String? image;
  @override
  Widget build(BuildContext context) {
     final strings = context.l10n;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<UpdateProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AvatarCubit>(),
        ),
      ],
      child: Container(
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
                  strings.profileSetup,
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 22.h),
                ProfileAvatarUser(image:image ),
                SizedBox(height: 40.h),
                 ProfileSetupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}