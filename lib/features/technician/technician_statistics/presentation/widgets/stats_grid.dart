import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_statistics/domain/entities/technician_statistics_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.data});

  final TechnicianStatisticsDataEntity data;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    final items = <_StatItem>[
      _StatItem(title: strings.totalJobs, value: data.totalJobs, icon: Icons.work_outline),
      _StatItem(title: strings.assignedJobs, value: data.assignedJobs, icon: Icons.assignment_ind_outlined),
      _StatItem(title: strings.inProgressJobs, value: data.inProgressJobs, icon: Icons.timelapse_outlined),
      _StatItem(title: strings.completedJobs, value: data.completedJobs, icon: Icons.check_circle_outline),

      _StatItem(title: strings.totalQuotations, value: data.totalQuotations, icon: Icons.description_outlined),
      _StatItem(title: strings.pendingQuotations, value: data.pendingQuotations, icon: Icons.hourglass_top_outlined),
      _StatItem(title: strings.acceptedQuotations, value: data.acceptedQuotations, icon: Icons.verified_outlined),
      _StatItem(title: strings.totalRatings, value: data.totalRatings, icon: Icons.star_border),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) => _StatCard(item: items[index]),
    );
  }
}

class _StatItem {
  final String title;
  final int value;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${item.value}',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}