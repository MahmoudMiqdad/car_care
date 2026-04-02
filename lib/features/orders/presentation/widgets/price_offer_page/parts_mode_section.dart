
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/orders/presentation/pages/price_offer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartsModeSection extends StatelessWidget {
  const PartsModeSection({super.key, 
    required this.withinPrice,
    required this.onChanged,
  });

  final bool withinPrice;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'القطع المطلوبة',
          textAlign: TextAlign.right,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.black,
            fontSize: 17.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: ModeChip(
                label: 'ضمن السعر',
                selected: withinPrice,
                onTap: () => onChanged(true),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ModeChip(
                label: 'سعر إضافي',
                selected: !withinPrice,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
