import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RingCard extends StatelessWidget {
  const RingCard({
    super.key,
    required this.title,
    required this.mainValue,
    required this.subLabel,
    required this.subValue,
    required this.progress,
  });

  final String title;
  final int mainValue;
  final String subLabel;
  final int subValue;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);

    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 86.w,
              height: 86.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 86.w,
                    height: 86.w,
                    child: CircularProgressIndicator(
                      value: p,
                      strokeWidth: 10.w,
                      backgroundColor: AppColors.lightScaffold,
                      color: AppColors.primary,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$mainValue',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'الإجمالي',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$subLabel: ', style: TextStyle(fontSize: 13.sp)),
                Text(
                  '$subValue',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}