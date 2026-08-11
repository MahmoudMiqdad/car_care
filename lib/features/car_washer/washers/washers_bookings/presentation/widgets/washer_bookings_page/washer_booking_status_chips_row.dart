import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Background/border for the washer-side status chip, resolved from the
/// canonical `status` (never from the Arabic `statusText`/label — a label
/// like "قيد التنفيذ" never contains the English words a substring check
/// would look for, which is why every status used to render identically).
/// Top-level so it's directly unit-testable.
({Color background, Color border}) washerBookingChipStyleFor(String status) {
  switch (status) {
    case 'completed':
      return (
        background: AppColors.serviceTierSelectedBackground,
        border: AppColors.success,
      );
    case 'cancelled':
      return (background: const Color(0xFFF8D7DA), border: AppColors.error);
    default: // pending / accepted / in_progress
      return (background: Colors.transparent, border: AppColors.lightBorder);
  }
}

class WasherBookingStatusChipsRow extends StatelessWidget {
  const WasherBookingStatusChipsRow({
    super.key,
    required this.status,
    required this.label,
  });

  /// Canonical status (pending/accepted/in_progress/completed/cancelled) —
  /// drives the color.
  final String status;

  /// Arabic display text (e.g. `booking.statusText`) — display only.
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = washerBookingChipStyleFor(status);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: style.border, width: 0.8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
