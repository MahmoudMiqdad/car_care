import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_indicators_section.dart';
import 'package:car_care/features/technician/technician_statistics/domain/entities/technician_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class TechnicianIndicatorsCard extends StatelessWidget {
  const TechnicianIndicatorsCard({super.key, required this.data});

  final TechnicianStatisticsDataEntity data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsIndicatorsSection(
      title: l10n.statusDetailsTitle,
      icon: Icons.checklist_outlined,
      items: [
        StatsIndicatorData(
          label: l10n.assignedStatusLabel,
          value: data.assignedJobs,
          icon: Icons.assignment_ind_outlined,
          color: AppColors.primary,
        ),
        StatsIndicatorData(
          label: l10n.bookingStatusProgress,
          value: data.inProgressJobs,
          icon: Icons.timelapse_outlined,
          color: AppColors.carWashTeal,
        ),
        StatsIndicatorData(
          label: l10n.completed,
          value: data.completedJobs,
          icon: Icons.check_circle_outline,
          color: AppColors.green,
        ),
        StatsIndicatorData(
          label: l10n.pending,
          value: data.pendingQuotations,
          icon: Icons.hourglass_top_outlined,
          color: AppColors.accent,
        ),
        StatsIndicatorData(
          label: l10n.bookingStatusAccepted,
          value: data.acceptedQuotations,
          icon: Icons.verified_outlined,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
