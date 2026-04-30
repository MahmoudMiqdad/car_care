// ignore_for_file: deprecated_member_use
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingsServiceInfoCard extends StatelessWidget {
  const RatingsServiceInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.lightBorder.withOpacity(0.5)),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Container(
            width: 85.w,
            height: 85.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lightBorder, width: 1),
              image: DecorationImage(
                image: AssetImage(AppAssets.washersPatternBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),          
          SizedBox(width: 16.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.sectionTitle(
                  strings.bookingsWasherName,
                  color: AppColors.black,
                  fontSize: 20.sp,
                ),
                  AppText.sectionTitle(
                  '${strings.bookingsServiceLabel} : ${strings.bookingsServiceVip}',
                  color: AppColors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                AppText.sectionTitle(
                  '${strings.bookingsDateTimeLabel} : 15/4 ${strings.bookingsAtLabel} 4:00',
                  color: AppColors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                AppText.sectionTitle(
                  '${strings.bookingsPriceLabel} : 20\$',
                  color: AppColors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}