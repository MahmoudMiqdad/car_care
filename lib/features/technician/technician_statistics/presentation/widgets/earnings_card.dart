import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.totalEarnings});
  final int totalEarnings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsSectionCard(
      title: l10n.netEarningsLabel,
      icon: Icons.payments_outlined,
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.payments_outlined,
              color: AppColors.accent,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.invoiceTotal,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          Text(
            l10n.currencyFormat(totalEarnings.toString()),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
