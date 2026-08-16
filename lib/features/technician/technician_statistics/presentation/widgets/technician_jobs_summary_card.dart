import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_segmented_bar.dart';
import 'package:car_care/core/widgets/statistics/stats_summary_card.dart';
import 'package:car_care/features/technician/technician_statistics/domain/entities/technician_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class TechnicianJobsSummaryCard extends StatelessWidget {
  const TechnicianJobsSummaryCard({super.key, required this.data});

  final TechnicianStatisticsDataEntity data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsSummaryCard(
      title: 'الأعمال',
      valueLabel: 'الإجمالي',
      value: data.totalJobs,
      icon: Icons.work_outline,
      segments: [
        StatsSegment(value: data.assignedJobs, color: AppColors.primary),
        StatsSegment(value: data.inProgressJobs, color: AppColors.carWashTeal),
        StatsSegment(value: data.completedJobs, color: AppColors.success),
      ],
      legendItems: [
        StatsLegendItem(
          label: l10n.completed,
          value: data.completedJobs,
          color: AppColors.success,
        ),
      ],
    );
  }
}
