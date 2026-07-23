import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:car_care/core/widgets/statistics/stats_grid.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderStatisticsOrdersCard extends StatelessWidget {
  const ProviderStatisticsOrdersCard({super.key, required this.statistics});

  final FuelProviderStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = statistics.totalOrders;
    final completed = statistics.completedOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          l10n.providerStatisticsTotalOrdersTitle,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        RingCard(
          data: RingCardData(
            title: l10n.showRatingAllReserved,
            headerIcon: Icons.receipt_long_outlined,
            accentColor: AppColors.primary,
            mainValue: total,
            mainLabel: 'الإجمالي',
            progress: total == 0 ? 0.0 : completed / total,
            indicators: [
              RingIndicator(
                label: l10n.completed,
                value: completed,
                icon: Icons.check_circle_outline,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        StatsGrid(
          items: [
            StatTileData(
              title: l10n.pending,
              value: '${statistics.pendingOrders}',
              icon: Icons.hourglass_top_outlined,
              color: AppColors.orange,
            ),
            StatTileData(
              title: l10n.bookingStatusAccepted,
              value: '${statistics.acceptedOrders}',
              icon: Icons.verified_outlined,
              color: AppColors.primary,
            ),
            StatTileData(
              title: l10n.bookingStatusProgress,
              value: '${statistics.inProgressOrders}',
              icon: Icons.timelapse_outlined,
              color: AppColors.primary,
            ),
            StatTileData(
              title: l10n.cancelled,
              value: '${statistics.cancelledOrders}',
              icon: Icons.cancel_outlined,
              color: AppColors.orange,
            ),
          ],
        ),
      ],
    );
  }
}