import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color:AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(
                  line,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
