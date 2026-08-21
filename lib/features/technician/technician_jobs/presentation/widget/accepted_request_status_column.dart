import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widget/accepted_request_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptedRequestStatusColumn extends StatelessWidget {
  const AcceptedRequestStatusColumn({super.key, required this.activePhase});

  final AcceptedRequestWorkPhase activePhase;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final phases = [
      (phase: AcceptedRequestWorkPhase.finished, label: l10n.bookingStatusCompleted),
      (phase: AcceptedRequestWorkPhase.inProgress, label: l10n.processingStatusLabel),
      (phase: AcceptedRequestWorkPhase.waiting, label: l10n.pending),
    ];

    return SizedBox(
      width: 92.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < phases.length; i++) ...[
              if (i > 0) SizedBox(height: 8.h),
              StatusBadge(
                label: phases[i].label,
                isActive: activePhase == phases[i].phase,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key, 
    required this.label,
    required this.isActive,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isActive ? AppColors.green : AppColors.primary;
    final Color bg = isActive ? AppColors.green.withValues(alpha: 0.12) : AppColors.white;
    final Color textColor = isActive ? AppColors.green : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}
