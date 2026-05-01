import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetailsLocationCard extends StatelessWidget {
  const WasherDetailsLocationCard({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              AppAssets.iconLocationPin,
              width: 32.r,
              height: 32.r,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText.sectionTitle(
                    context.l10n.washerSectionCityAndAddress,
                    color: AppColors.lightTextPrimary,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    washer.fullAddress.isEmpty ? washer.city : washer.fullAddress,
                    textAlign: TextAlign.left,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}