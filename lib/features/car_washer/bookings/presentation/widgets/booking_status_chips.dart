import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n.dart';

class BookingStatusChips extends StatelessWidget {
  const BookingStatusChips({required this.statusChips, super.key});

  final List<String> statusChips;

  @override
  Widget build(BuildContext context) {
    return Row(children: [...statusChips.map(BookingStatusChip.new)]);
  }
}

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final acceptedLabel = context.l10n.bookingStatusAccepted;
    final progressLabel = context.l10n.bookingStatusProgress;

    final color = switch (label) {
      _ when label == acceptedLabel => AppColors.serviceTierSelectedBackground,
      _ when label == progressLabel => const Color(0xFFBCE5F8),
      _ => const Color(0xFFD1EAF8),
    };

    return Padding(
      padding: EdgeInsets.only(left: 6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: AppColors.primary, width: 0.8),
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
