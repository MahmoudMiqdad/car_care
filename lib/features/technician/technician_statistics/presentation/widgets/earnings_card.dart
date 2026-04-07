import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.totalEarnings});
  final int totalEarnings;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(Icons.payments_outlined, color: AppColors.primary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'صافي الأرباح:',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '\$$totalEarnings',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}