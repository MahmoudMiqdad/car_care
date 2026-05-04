import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherAboutSection extends StatelessWidget {
  const ProfileWasherAboutSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          l10n.profileWasherAboutTitle,
          color: AppColors.black,
          textAlign: TextAlign.right,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.carWashTeal, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.carWashTeal.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Icon(
                      Icons.local_car_wash_rounded,
                      color: AppColors.carWashTeal,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    description,
                    textAlign: TextAlign.start,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5.sp,
                      height: 1.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
