import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProviderStatisticsProfitsCard extends StatelessWidget {
  const ProviderStatisticsProfitsCard({super.key, required this.statistics});

  final FuelProviderStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formattedProfits = NumberFormat('#,###').format(statistics.totalRevenue);

    return StatsSectionCard(
      title: l10n.providerStatisticsTotalProfitsTitle,
      icon: Icons.payments_outlined,
      child: Row(
        children: [ 
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Image.asset(AppAssets.fuelOrderMoneyIcon, fit: BoxFit.contain),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.invoiceTotal,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black.withValues(alpha: 0.87),
              ),
            ),
          ),
          Text(
            l10n.currencyFormat(formattedProfits),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
