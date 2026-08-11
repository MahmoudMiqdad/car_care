import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Background/border for the customer-side status chip, resolved from the
/// canonical `status` (never the Arabic label). Top-level so it's directly
/// unit-testable.
({Color background, Color border}) customerBookingChipStyleFor(String status) {
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

class BookingStatusChips extends StatelessWidget {
  const BookingStatusChips({
    required this.status,
    required this.label,
    super.key,
  });

  /// Canonical status (pending/accepted/in_progress/completed/cancelled).
  final String status;

  /// Arabic display text (e.g. `booking.statusText`) — display only.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [BookingStatusChip(status: status, label: label)],
    );
  }
}

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({
    required this.status,
    required this.label,
    super.key,
  });

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = customerBookingChipStyleFor(status);

    return Padding(
      padding: EdgeInsets.only(left: 6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: style.border, width: 0.8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
