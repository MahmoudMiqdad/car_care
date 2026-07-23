import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ProviderStatisticsProfitsCard extends StatelessWidget {
  const ProviderStatisticsProfitsCard({super.key, required this.statistics});

  final FuelProviderStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formattedProfits =
        NumberFormat('#,###').format(statistics.totalOrders);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          l10n.providerStatisticsTotalProfitsTitle,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        AppBoxContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Image.asset(
                    AppAssets.fuelOrderMoneyIcon,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'الإجمالي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '\$ $formattedProfits',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.orange,
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