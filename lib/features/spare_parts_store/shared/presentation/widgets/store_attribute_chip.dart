import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum StoreAttributeType { businessType, carBrand, partCategory }

class StoreAttributeChip extends StatelessWidget {
  const StoreAttributeChip({
    super.key,
    required this.label,
    required this.type,
  });

  final String label;
  final StoreAttributeType type;

  Color get _color => switch (type) {
    StoreAttributeType.businessType => AppColors.accent,
    StoreAttributeType.carBrand => AppColors.green,
    StoreAttributeType.partCategory => AppColors.accent,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
