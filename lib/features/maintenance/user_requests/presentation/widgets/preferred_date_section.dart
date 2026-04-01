import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferredDateSection extends StatelessWidget {
  const PreferredDateSection({
    super.key,
    required this.cardRadius,
    required this.formattedDate,
    required this.onPickDate,
  });

  final double cardRadius;
  final String formattedDate;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return RequestsFormCard(
      cardRadius: cardRadius,
      title: 'اختيار التاريخ المفضل',
      icon: Icons.calendar_today,
      iconColor: AppColors.info,
      child: InkWell(
        onTap: onPickDate,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary.withValues(alpha: 0.85),
                ),
              ),
              Icon(Icons.chevron_left, color: AppColors.primary, size: 22.sp),
            ],
          ),
        ),
      ),
    );
  }
}
