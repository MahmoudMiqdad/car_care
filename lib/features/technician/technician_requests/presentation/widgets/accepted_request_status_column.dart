
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_requests/presentation/widgets/accepted_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AcceptedRequestStatusColumn extends StatelessWidget {
  const AcceptedRequestStatusColumn({super.key, required this.activePhase});

  final AcceptedRequestWorkPhase activePhase;

  static const List<({AcceptedRequestWorkPhase phase, String label})> _phases =
      [
    (phase: AcceptedRequestWorkPhase.finished, label: 'منتهية'),
    (phase: AcceptedRequestWorkPhase.inProgress, label: 'قيد التنفيذ'),
    (phase: AcceptedRequestWorkPhase.waiting, label: 'إنتظار'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _phases.length; i++) ...[
              if (i > 0) SizedBox(height: 8.h),
              StatusBadge(
                label: _phases[i].label,
                isActive: activePhase == _phases[i].phase,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, 
    required this.label,
    required this.isActive,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isActive ? AppColors.success : AppColors.primary;
    final Color bg = isActive ? const Color(0xFFE8F5E9) : AppColors.white;
    final Color textColor = isActive ? AppColors.success : AppColors.primary;

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
