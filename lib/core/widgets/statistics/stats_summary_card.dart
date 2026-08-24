import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:car_care/core/widgets/statistics/stats_segmented_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsLegendItem {
  const StatsLegendItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({
    super.key,
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.segments,
    this.legendItems = const [],
    this.icon,
  });

  final String title;
  final String valueLabel;
  final int value;
  final List<StatsSegment> segments;
  final List<StatsLegendItem> legendItems;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final nonZeroLegend = legendItems.where((item) => item.value > 0).toList();
    final colorScheme = context.colorScheme;

    return StatsSectionCard(
      title: title,
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              height: 1,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            valueLabel,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 14.h),
          StatsSegmentedBar(segments: segments),
          if (nonZeroLegend.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              children: [
                for (final item in nonZeroLegend) _LegendChip(item: item),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.item});

  final StatsLegendItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '${item.label} ${item.value}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}
