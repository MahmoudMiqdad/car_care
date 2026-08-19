import 'dart:io';
import 'package:car_care/core/extensions/theme_extension.dart'; 
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/dashed_border_box.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateProfileWasherLogoSection extends StatelessWidget {
  const CreateProfileWasherLogoSection({
    super.key,
    this.logoPath,
    this.onTap,
    this.uploadLabel,
  });

  final String? logoPath;
  final VoidCallback? onTap;
  final String? uploadLabel;

  static const double _size = 104;
  static const Color _dashColor = AppColors.white;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLogo = logoPath != null && logoPath!.isNotEmpty;
    final diameter = _size.r;

    return Center(
      child: Column(
        children: [
          Material(
            color: AppColors.transparent, 
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
                    color: AppColors.white,
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
            uploadLabel ?? l10n.uploadLogoLabel, 
            style: context.textTheme.bodyMedium!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
