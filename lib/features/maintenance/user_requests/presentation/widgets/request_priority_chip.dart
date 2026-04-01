import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestPriorityChip extends StatelessWidget {
  const RequestPriorityChip({
    super.key,
    required this.label,
    required this.style,
    required this.onTap,
  });

  final String label;
  final PriorityChipStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = AppConstants.maintenanceRequestCardRadius.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(r),
        child: AnimatedContainer(
          duration: AppConstants.defaultDuration,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: style.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
