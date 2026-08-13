import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single, unified white card wrapper for statistics sections — the
/// "غلاف قسم موحّد" reused across [StatsSummaryCard]/
/// [StatsIndicatorsSection] and any future statistics screen (fuel
/// provider / technician / shop owner). Purely presentational: it knows
/// nothing about any Cubit, repository, or business entity.
class StatsSectionCard extends StatelessWidget {
  const StatsSectionCard({
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    required this.child,
  });

  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20.sp,
                    color: iconColor ?? AppColors.carWashTeal,
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
          child,
        ],
      ),
    );
  }
}
