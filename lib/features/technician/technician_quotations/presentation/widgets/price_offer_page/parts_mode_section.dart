import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/pages/technician_quotations_page.dart';
import 'package:car_care/l10n.dart';
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
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.requiredPartsLabel,
          style: context.textTheme.bodyMedium!.copyWith(
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
                label: l10n.includedInPriceLabel,
                selected: withinPrice,
                onTap: () => onChanged(true),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ModeChip(
                label: l10n.additionalPriceLabel,
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
