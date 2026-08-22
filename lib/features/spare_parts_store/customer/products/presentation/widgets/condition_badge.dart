// شارة تعرض حالة المنتج: جديد أو مستعمل
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConditionBadge extends StatelessWidget {
  const ConditionBadge({super.key, required this.isNew});

  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 
    final color = isNew ? AppColors.green : AppColors.accent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15), 
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isNew ? l10n.conditionNew : l10n.conditionUsed,
        style: context.textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
