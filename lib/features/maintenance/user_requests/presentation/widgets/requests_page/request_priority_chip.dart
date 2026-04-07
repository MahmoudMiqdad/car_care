import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestPriorityChip extends StatelessWidget {
  const RequestPriorityChip({
    super.key,
    required this.label,
    required this.style,
    this.padding,
  });

  final String label;
  final PriorityChipStyle style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final r = 20.r; 
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h);

    return Container(
      alignment: Alignment.center, 
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(
          color: style.borderColor,
          width: 1, 
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: style.textColor,
        ),
      ),
    );
  }
}