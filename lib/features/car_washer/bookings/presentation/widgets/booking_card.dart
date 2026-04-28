import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import 'booking_action_menu.dart';
import 'booking_details_content.dart';
import 'booking_status_chips.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.statusChips,
    this.showMenuByDefault = false,
  });

  final List<String> statusChips;
  final bool showMenuByDefault;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.lightBorder),
          ),
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingStatusChips(statusChips: statusChips),
              SizedBox(height: 8.h),
              const BookingDetailsContent(),
            ],
          ),
        ),
        Positioned(
          left: 6.w,
          top: 8.h,
          child: showMenuByDefault
              ? const BookingActionMenu(showAsOpen: true)
              : const BookingActionMenu(),
        ),
      ],
    );
  }
}
