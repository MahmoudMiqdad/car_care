// ignore_for_file: file_names
import 'dart:io';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateVehicleImage extends StatelessWidget {
  final String? networkImage;
  final String? pickedImagePath;
  final VoidCallback onPickImage;

  const UpdateVehicleImage({
    super.key,
    this.networkImage,
    this.pickedImagePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: InkWell(
        onTap: onPickImage,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 170.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.45),
              width: 1.2,
            ),
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
                      : Icon(
                          Icons.directions_car,
                          size: 50.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
