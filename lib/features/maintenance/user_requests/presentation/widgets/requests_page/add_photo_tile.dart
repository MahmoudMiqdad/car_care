import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/dashed_border_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPhotoTile extends StatelessWidget {
  const AddPhotoTile({super.key, required this.cardRadius, required this.onTap});

  final double cardRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: DashedBorderBox(
        color: AppColors.primary,
        borderRadius: cardRadius,
        child: SizedBox(
          width: 45.w,
          height: 45.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary, size: 16.sp),
              Text(
                'إضافة',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
