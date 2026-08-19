import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_segmented_bar.dart';
import 'package:car_care/core/widgets/statistics/stats_summary_card.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class ProviderStatisticsOrdersCard extends StatelessWidget {
  const ProviderStatisticsOrdersCard({super.key, required this.statistics});

  final FuelProviderStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsSummaryCard(
      title: l10n.providerStatisticsTotalOrdersTitle,
      valueLabel: l10n.providerStatisticsTotalOrdersTitle,
      value: statistics.totalOrders,
      icon: Icons.event_note_outlined,
      segments: [
        StatsSegment(value: statistics.pendingOrders, color: AppColors.orange),
        StatsSegment(
          value: statistics.acceptedOrders,
          color: AppColors.primary,
        ),
        StatsSegment(
          value: statistics.inProgressOrders,
          color: AppColors.carWashTeal,
        ),
        StatsSegment(
          value: statistics.completedOrders,
          color: AppColors.green,
        ),
        StatsSegment(value: statistics.cancelledOrders, color: AppColors.red),
      ],
      legendItems: [
        StatsLegendItem(
          label: l10n.completed,
          value: statistics.completedOrders,
          color: AppColors.green,
        ),
        StatsLegendItem(
          label: l10n.cancelled,
          value: statistics.cancelledOrders,
          color: AppColors.red,
        ),
      ],
    );
  }
}
