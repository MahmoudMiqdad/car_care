// ignore_for_file: file_names

import 'dart:io';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatarUser extends StatelessWidget {
  const ProfileAvatarUser({super.key, this.image, this.radius = 60});

  final String? image;
  final double radius;

  void _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (!context.mounted || pickedFile == null) return;

    context.read<AvatarCubit>().updateAvatar(avatar: pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AvatarCubit, AvatarState>(
      listener: (context, state) {
        if (state is AvatarUpdated) {
          AppSnackBar.success(context, l10n.avatarUpdatedSuccess);
        }
        if (state is AvatarError) {
          AppSnackBar.error(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AvatarLoading;
        ImageProvider? avatarImage;

        if (state is AvatarUpdated) {
          final path = state.profile.avatarUrl;
          if (path.startsWith('http')) {
            avatarImage = NetworkImage(path);
          } else {
            avatarImage = FileImage(File(path));
          }
        } else if (image != null && image!.isNotEmpty) {
          avatarImage = NetworkImage(image!);
        }

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: radius.r,
              backgroundColor: AppColors.secondary,
              backgroundImage: avatarImage,
              child: avatarImage == null
                  ? Icon(
                      Icons.person,
                      size: 100.sp,
                      color: AppColors.textSecondary(context),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 4.w,
              child: GestureDetector(
                onTap: isLoading ? null : () => _pickImage(context),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
