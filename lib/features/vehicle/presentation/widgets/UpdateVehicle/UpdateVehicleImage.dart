// ignore_for_file: deprecated_member_use, file_names
import 'dart:io';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class UpdateVehicleImage extends StatelessWidget {
  final String? networkImage;
  final String? pickedImagePath;
  final VoidCallback onPickImage;

  const UpdateVehicleImage({super.key, 
    this.networkImage,
    this.pickedImagePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: InkWell(
        onTap: onPickImage,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 170.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF0C5D6E).withOpacity(0.45), width: 1.2),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: pickedImagePath != null
                      ? Image.file(File(pickedImagePath!), fit: BoxFit.cover)
                      : (networkImage != null && networkImage!.isNotEmpty)
                          ? Image.network(networkImage!, fit: BoxFit.cover)
                          : Icon(Icons.directions_car, size: 50.sp, color: Colors.grey),
                ),
              ),
              Positioned(
                bottom: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}