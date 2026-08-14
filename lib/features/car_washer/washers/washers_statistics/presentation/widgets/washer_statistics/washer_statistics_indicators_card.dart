import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_indicators_section.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class WasherStatisticsIndicatorsCard extends StatelessWidget {
  const WasherStatisticsIndicatorsCard({super.key, required this.statistics});

  final StatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return StatsIndicatorsSection(
      title: 'حالات الحجوزات',
      icon: Icons.checklist_outlined,
      items: [
        StatsIndicatorData(
          label: strings.pending,
          value: statistics.pendingBookings,
          icon: Icons.hourglass_top_outlined,
          color: AppColors.orange,
        ),
        StatsIndicatorData(
          label: strings.bookingStatusAccepted,
          value: statistics.acceptedBookings,
          icon: Icons.verified_outlined,
          color: AppColors.primary,
        ),
        StatsIndicatorData(
          label: strings.bookingStatusProgress,
          value: statistics.inProgressBookings,
          icon: Icons.timelapse_outlined,
          color: AppColors.carWashTeal,
        ),
      ],
    );
  }
}
