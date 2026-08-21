import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTriggerField extends StatelessWidget {
  const SelectTriggerField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder = '—',
    this.leading,
    this.borderColor = AppColors.primary,
    this.borderWidth = 1.5,
    this.labelColor,
    this.labelFontSize = 15,
    this.chevronLeading = false,
    this.placeholderAlpha = 0.55,
    this.labelHeight,
    this.valueHeight,
    this.labelValueGap = 2,
  });

  final String label;
  final VoidCallback onTap;

  final String? value;
  final String placeholder;

  final Widget? leading;

  final Color borderColor;
  final double borderWidth;
  final Color? labelColor;
  final double labelFontSize;

  final bool chevronLeading;

  final double placeholderAlpha;
  final double? labelHeight;
  final double? valueHeight;
  final double labelValueGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value != null && value!.isNotEmpty;
    final chevron = Icon(
      Icons.keyboard_arrow_down_rounded,
      color: borderColor,
      size: 28.sp,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (chevronLeading) ...[
                  chevron,
                  SizedBox(width: 12.w),
                ] else if (leading != null) ...[
                  leading!,
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: labelColor ?? AppColors.textPrimary(context),
                          fontWeight: FontWeight.w700,
                          fontSize: labelFontSize.sp,
                          height: labelHeight,
                        ),
                      ),
                      if (labelValueGap > 0) SizedBox(height: labelValueGap.h),
                      Text(
                        hasValue ? value! : placeholder,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: hasValue
                              ? AppColors.textSecondary(
                                  context,
                                ).withValues(alpha: 0.85)
                              : AppColors.textSecondary(
                                  context,
                                ).withValues(alpha: placeholderAlpha),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: valueHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!chevronLeading) chevron,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
