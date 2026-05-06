import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../l10n.dart';
import '../../../../../../core/theme/app_colors.dart';

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Text(
            context.l10n.bookingsFilterByStatus,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          Icon(Icons.expand_more, size: 22.sp),
        ],
      ),
    );
  }
}
