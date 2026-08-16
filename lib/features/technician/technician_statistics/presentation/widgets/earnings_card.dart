import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.totalEarnings});
  final int totalEarnings;

  @override
  Widget build(BuildContext context) {
    return StatsSectionCard(
      title: 'صافي الأرباح',
      icon: Icons.payments_outlined,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.payments_outlined,
              color: AppColors.orange,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'الإجمالي',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            '\$$totalEarnings',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
