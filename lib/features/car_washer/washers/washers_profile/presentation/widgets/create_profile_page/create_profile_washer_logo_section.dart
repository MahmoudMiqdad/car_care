import 'dart:io';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/dashed_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateProfileWasherLogoSection extends StatelessWidget {
  const CreateProfileWasherLogoSection({
    super.key,
    this.logoPath,
    this.onTap,
    this.uploadLabel = 'رفع الشعار',
  });

  final String? logoPath;
  final VoidCallback? onTap;
  final String uploadLabel;

  static const double _size = 104;
  static const Color _dashColor = Color(0xFFBFD8D6);

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoPath != null && logoPath!.isNotEmpty;
    final diameter = _size.r;

    return Center(
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: DashedBorderBox(
                color: _dashColor,
                borderRadius: diameter / 2,
                strokeWidth: 2,
                child: Container(
                  width: diameter,
                  height: diameter,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: hasLogo
                      ? ClipOval(
                          child: Image.file(
                            File(logoPath!),
                            fit: BoxFit.cover,
                            width: diameter,
                            height: diameter,
                          ),
                        )
                      : Icon(
                          Icons.cloud_upload_outlined,
                          size: 34.sp,
                          color: AppColors.carWashTeal,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            uploadLabel,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
