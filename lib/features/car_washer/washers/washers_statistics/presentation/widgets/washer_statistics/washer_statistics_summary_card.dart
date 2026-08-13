import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_segmented_bar.dart';
import 'package:car_care/core/widgets/statistics/stats_summary_card.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

/// Adapts [StatisticsEntity] into the simple view data the generic
/// [StatsSummaryCard] needs — the washer statistics page stays responsible
/// for this conversion, the shared widget knows nothing about bookings.
class WasherStatisticsSummaryCard extends StatelessWidget {
  const WasherStatisticsSummaryCard({super.key, required this.statistics});

  final StatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return StatsSummaryCard(
      title: strings.showRatingAllReserved,
      valueLabel: strings.showRatingTotalBookings,
      value: statistics.totalBookings,
      icon: Icons.event_note_outlined,
      segments: [
        StatsSegment(
          value: statistics.pendingBookings,
          color: AppColors.orange,
        ),
        StatsSegment(
          value: statistics.acceptedBookings,
          color: AppColors.primary,
        ),
        StatsSegment(
          value: statistics.inProgressBookings,
          color: AppColors.carWashTeal,
        ),
        StatsSegment(
          value: statistics.completedBookings,
          color: AppColors.success,
        ),
        StatsSegment(
          value: statistics.cancelledBookings,
          color: AppColors.error,
        ),
      ],
      legendItems: [
        StatsLegendItem(
          label: strings.completed,
          value: statistics.completedBookings,
          color: AppColors.success,
        ),
        StatsLegendItem(
          label: strings.cancelled,
          value: statistics.cancelledBookings,
          color: AppColors.error,
        ),
      ],
    );
  }
}
