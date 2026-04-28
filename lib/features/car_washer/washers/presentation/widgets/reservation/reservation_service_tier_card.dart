import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationServiceTierCard extends StatelessWidget {
  const ReservationServiceTierCard({
    super.key,
    required this.title,
    required this.priceAmount,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int priceAmount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: Material(
        color: isSelected
            ? AppColors.serviceTierSelectedBackground
            : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.carWashTeal,
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.carWashTeal.withValues(alpha: 0.4),
                  ),
                ),
                Text(
                  l10n.washerPackagePrice(priceAmount),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
