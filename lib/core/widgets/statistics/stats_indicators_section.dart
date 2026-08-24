import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsIndicatorData {
  const StatsIndicatorData({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
}

class StatsIndicatorsSection extends StatelessWidget {
  const StatsIndicatorsSection({
    super.key,
    required this.title,
    required this.items,
    this.icon,
  });

  final String title;
  final List<StatsIndicatorData> items;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return StatsSectionCard(
      title: title,
      icon: icon,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            StatsIndicatorItem(data: items[i]),
            if (i != items.length - 1) SizedBox(height: 4.h),
          ],
        ],
      ),
    );
  }
}

class StatsIndicatorItem extends StatelessWidget {
  const StatsIndicatorItem({super.key, required this.data});

  final StatsIndicatorData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(data.icon, size: 17.sp, color: data.color),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            '${data.value}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }
}
