// ignore_for_file: file_names
import 'dart:io';

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/l10n.dart';
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
    final strings = context.l10n;
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
            border: Border.all(color: colorScheme.primary),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
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
                              Icon(
                                Icons.directions_car_filled_outlined,
                                size: 52.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                strings.addVehicleImage,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                strings.tapToSelectImage,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: colorScheme.onSurfaceVariant,
                                ),
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
