// ignore_for_file: file_names

import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.person,
            size: 100.sp,
            color: Colors.grey.shade400,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4.w,
          child: GestureDetector(
            onTap: () {
              // أضف كود فتح الكاميرا   
            },
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
