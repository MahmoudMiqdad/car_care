// ignore_for_file: file_names

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/user_profile/presentation/widgets/delete_confirmation_dialog.dart';

import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileInfoCard.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_state.dart';
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

    return BlocListener<AvatarCubit, AvatarState>(
      listener: (context, state) {
        if (state is AvatarUpdated || state is AvatarDeleted) {
          context.read<ShowProfileCubit>().getProfile();
        }
      },
      child: BlocBuilder<ShowProfileCubit, ShowProfileState>(
      builder: (context, state) {
        if (state is ShowProfileLoading) {
          return const Center(child: AppLoadingWidget());
        }
        if (state is ShowProfileError) {
          return Center(
            child: Text(localizeErrorMessage(context, state.message)),
          );
        }
        if (state is ShowProfileLoaded) {
          final profile = state.profile;
          final colorScheme = context.colorScheme;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ShowProfileCubit>().getProfile();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatarUser(image: profile.avatar, radius: 60),
                    SizedBox(height: 8.h),
                    Text(
                      profile.name,
                      style: TextStyle(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
                      onPressed: () async {
                        await context.push(
                          Routes.profile_setup,
                          extra: profile,
                        );
                        if (context.mounted) {
                          context.read<ShowProfileCubit>().getProfile();
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: strings.editPassword,
                      onPressed: () => context.push(Routes.changepasswordpage),
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: strings.delete,
                      isOutline: true,
                      backgroundColor: colorScheme.error,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const DeleteProfileDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
      ),
    );
  }
}
