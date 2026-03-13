// ignore_for_file: file_names

import 'package:car_care/features/vehicle/presentation/widgets/RefreshHint.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehiclesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehiclesBody extends StatelessWidget {
  const VehiclesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 16.h,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          const RefreshHint(),
          SizedBox(height: 27.h),
          const Expanded(
            child: VehiclesList(
              items: [
                VehicleItem(
                  imageAsset: 'assets/images/1.png',
                  name: 'فيراري سبورت',
                  year: '2025',
                  plateNumber: '18-569847',
                  mileage: '155,000',
                ),
                VehicleItem(
                  imageAsset: 'assets/images/1.png',
                  name: 'سابا ١٣٠',
                  year: '2006',
                  plateNumber: '215464',
                  mileage: '265,000',
                ),
        
              ],
            ),
          ),
        ],
      ),
    );
  }
}