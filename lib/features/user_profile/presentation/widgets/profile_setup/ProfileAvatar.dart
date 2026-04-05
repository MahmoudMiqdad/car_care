import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_state.dart';

class ProfileAvatarUser extends StatelessWidget {
  final String? image;
  final double radius;

  const ProfileAvatarUser({super.key, this.image, this.radius = 60});


  void _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (!context.mounted || pickedFile == null) return;

    context.read<AvatarCubit>().updateAvatar(avatar: pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AvatarCubit, AvatarState>(
      listener: (context, state) {
        if (state is AvatarUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الصورة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is AvatarError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AvatarLoading;

        // تحديد الصورة التي ستظهر
        ImageProvider? avatarImage;

        if (state is AvatarUpdated) {
          // الصورة الجديدة من الجهاز
          final path = state.profile.avatarUrl;
          if (path.startsWith('http')) {
            avatarImage = NetworkImage(path);
          } else {
            avatarImage = FileImage(File(path));
          }
        } else if (image != null && image!.isNotEmpty) {
          avatarImage = NetworkImage(image!);
        }

      
        avatarImage ??= const AssetImage('assets/default_avatar.png');

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: radius.r,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: avatarImage,
              child: avatarImage is AssetImage
                  ? Icon(Icons.person, size: 100.sp, color: Colors.grey.shade400)
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
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}