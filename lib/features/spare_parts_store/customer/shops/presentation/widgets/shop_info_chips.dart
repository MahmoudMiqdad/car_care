// قائمة Chips لعرض مجموعة قيم نصية (نوع النشاط، ماركات السيارات، فئات القطع) مع عنوان
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_attribute_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopInfoChips extends StatelessWidget {
  const ShopInfoChips({
    super.key,
    required this.title,
    required this.values,
    required this.type,
    this.titleIcon,
  });

  final String title;
  final List<String> values;
  final StoreAttributeType type;
  final IconData? titleIcon;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (titleIcon != null) ...[
              Icon(titleIcon, size: 17.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
            ],
            Text(
              title,
              style: context.textTheme.labelLarge!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: values
              .map((value) => StoreAttributeChip(label: value, type: type))
              .toList(),
        ),
      ],
    );
  }
}
