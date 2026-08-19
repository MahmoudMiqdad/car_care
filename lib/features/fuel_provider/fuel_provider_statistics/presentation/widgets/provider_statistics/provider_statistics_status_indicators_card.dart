import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_indicators_section.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class ProviderStatisticsStatusIndicatorsCard extends StatelessWidget {
  const ProviderStatisticsStatusIndicatorsCard({
    super.key,
    required this.statistics,
  });

  final FuelProviderStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsIndicatorsSection(
      title: l10n.orderStatusesTitle,
      icon: Icons.checklist_outlined,
      items: [
        StatsIndicatorData(
          label: l10n.pending,
          value: statistics.pendingOrders,
          icon: Icons.hourglass_top_outlined,
          color: AppColors.orange,
        ),
        StatsIndicatorData(
          label: l10n.bookingStatusAccepted,
          value: statistics.acceptedOrders,
          icon: Icons.verified_outlined,
          color: AppColors.primary,
        ),
        StatsIndicatorData(
          label: l10n.bookingStatusProgress,
          value: statistics.inProgressOrders,
          icon: Icons.timelapse_outlined,
          color: AppColors.carWashTeal,
        ),
      ],
    );
  }
}
