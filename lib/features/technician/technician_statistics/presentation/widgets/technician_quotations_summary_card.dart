import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_segmented_bar.dart';
import 'package:car_care/core/widgets/statistics/stats_summary_card.dart';
import 'package:car_care/features/technician/technician_statistics/domain/entities/technician_statistics_entity.dart';
import 'package:flutter/material.dart';

class TechnicianQuotationsSummaryCard extends StatelessWidget {
  const TechnicianQuotationsSummaryCard({super.key, required this.data});

  final TechnicianStatisticsDataEntity data;

  @override
  Widget build(BuildContext context) {
    return StatsSummaryCard(
      title: 'العروض',
      valueLabel: 'الإجمالي',
      value: data.totalQuotations,
      icon: Icons.description_outlined,
      segments: [
        StatsSegment(value: data.pendingQuotations, color: AppColors.orange),
        StatsSegment(value: data.acceptedQuotations, color: AppColors.primary),
      ],
      legendItems: [
        StatsLegendItem(
          label: 'مقبولة',
          value: data.acceptedQuotations,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
