// ignore_for_file: deprecated_member_use, file_names
import 'dart:io';

import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleImageWidget extends StatelessWidget {
  const VehicleImageWidget({
    super.key,
    required this.imagePath,
    required this.onPickImage,
  });

  final String? imagePath;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: hasImage
                      ? Image.file(File(imagePath!), fit: BoxFit.cover)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car_filled_outlined, size: 52.sp, color: Colors.grey.shade500),
                              SizedBox(height: 10.h),
                              Text(
                                'أضف صورة المركبة',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'اضغط لاختيار صورة',
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
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