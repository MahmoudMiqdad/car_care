import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsRingsRow extends StatelessWidget {
  const StatsRingsRow({
    super.key,
    required this.quotationsTotal,
    required this.quotationsAccepted,
    required this.quotationsPending,
    required this.jobsTotal,
    required this.jobsCompleted,
    required this.jobsInProgress,
  });

  final int quotationsTotal;
  final int quotationsAccepted;
  final int quotationsPending;

  final int jobsTotal;
  final int jobsCompleted;
  final int jobsInProgress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RingCard(
            title: 'العروض',
            totalLabel: 'الإجمالي',
            totalValue: quotationsTotal,
            progressValue: quotationsTotal == 0
                ? 0
                : (quotationsAccepted / quotationsTotal),
            rows: [
              _MiniRow(label: 'المقبولة', value: quotationsAccepted),
              _MiniRow(label: 'المعلّقة', value: quotationsPending),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _RingCard(
            title: 'الأعمال',
            totalLabel: 'الإجمالي',
            totalValue: jobsTotal,
            progressValue: jobsTotal == 0 ? 0 : (jobsCompleted / jobsTotal),
            rows: [
              _MiniRow(label: 'المكتملة', value: jobsCompleted),
              _MiniRow(label: 'قيد التنفيذ', value: jobsInProgress),
            ],
          ),
        ),
      ],
    );
  }
}

class _RingCard extends StatelessWidget {
  const _RingCard({
    required this.title,
    required this.totalLabel,
    required this.totalValue,
    required this.progressValue,
    required this.rows,
  });

  final String title;
  final String totalLabel;
  final int totalValue;
  final double progressValue;
  final List<_MiniRow> rows;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 110.w,
              height: 110.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110.w,
                    height: 110.w,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 10.w,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primary.withOpacity(.15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110.w,
                    height: 110.w,
                    child: CircularProgressIndicator(
                      value: progressValue.clamp(0, 1),
                      strokeWidth: 10.w,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalValue',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        totalLabel,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            for (final r in rows) ...[
              _InfoLine(label: r.label, value: r.value),
              SizedBox(height: 6.h),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7.w,
          height: 7.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MiniRow {
  final String label;
  final int value;
  const _MiniRow({required this.label, required this.value});
}