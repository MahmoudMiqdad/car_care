// ignore_for_file: file_names

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/RequestMaintenanceButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/VehicleHeaderWidget.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehicleDetails/VehicleInfoCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VehicleDetailsBody extends StatelessWidget {
  const VehicleDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          const VehicleHeaderWidget(),
          SizedBox(height: 22.h),
          VehicleInfoCardWidget(
            title: 'عداد الكيلومترات',
            valueWidget: Text(
              '١٢٠,٠٠٠ كم',
              style: context.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20.sp,
              ),
            ),
            iconWidget: Icon(
              Icons.speed,
              color: AppColors.primary,
              size: 32.sp,
            ),
            onTap: () {},
          ),
          SizedBox(height: 16.h),
          VehicleInfoCardWidget(
            title: 'رقم اللوحة',
            valueWidget: Text(
              '٣٢٨٧٩٧',
              style: context.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20.sp,
              ),
            ),
            iconWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '1..',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            onTap: () {},
          ),
          SizedBox(height: 16.h),
          VehicleInfoCardWidget(
            title: 'حالة الصيانة',
            valueWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لا تحتاج صيانة',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ],
            ),
            iconWidget: Icon(
              Icons.handyman_outlined,
              color: AppColors.primary,
              size: 32.sp,
            ),
            onTap: () {},
          ),
          SizedBox(height: 22.h),
          const RequestMaintenanceButton(),
        ],
      ),
    );
  }
}

