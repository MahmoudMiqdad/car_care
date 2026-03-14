// ignore_for_file: file_names
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/SaveVehicleButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/VehicleImageWidget.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/VehicleTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddVehicleBody extends StatelessWidget {
  const AddVehicleBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const VehicleImageWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                VehicleTextField(
                  hintText: 'عداد الكيلومترات',
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
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                VehicleTextField(
                  hintText: 'اللوحة',
                  iconWidget: Text(
                    'AA',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                const VehicleTextField(
                  hintText: 'الماركة',
                  iconWidget: Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                const VehicleTextField(
                  hintText: 'الموديل',
                  iconWidget: Icon(
                    Icons.directions_car_outlined,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                const VehicleTextField(
                  hintText: 'السنة',
                  iconWidget: Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 20.h),
                const SaveVehicleButton(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}