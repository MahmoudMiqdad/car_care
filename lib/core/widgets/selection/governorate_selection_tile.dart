import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernorateSelectionTile extends StatelessWidget {
  const GovernorateSelectionTile({
    super.key,
    required this.label,
    required this.isSelected,
    this.selectedColor,
  });

  final String label;
  final bool isSelected;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final effectiveSelectedColor = selectedColor ?? colorScheme.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? effectiveSelectedColor.withValues(alpha: 0.1)
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? effectiveSelectedColor
              : colorScheme.outlineVariant,
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
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle_rounded,
              color: effectiveSelectedColor,
              size: 20.sp,
            ),
        ],
      ),
    );
  }
}
