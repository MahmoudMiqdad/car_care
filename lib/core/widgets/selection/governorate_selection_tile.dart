import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GovernorateSelectionTile extends StatelessWidget {
  const GovernorateSelectionTile({
    super.key,
    required this.label,
    required this.isSelected,
    this.selectedColor = AppColors.primary,
  });

  final String label;
  final bool isSelected;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? selectedColor.withValues(alpha: 0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? selectedColor : Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: selectedColor, size: 20.sp),
        ],
      ),
    );
  }
}
