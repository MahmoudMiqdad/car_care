// عنصر للتحكم بكمية المنتج المطلوبة عبر زيادة/تقليل
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove,
          onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        SizedBox(
          width: 28.w,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: context.textTheme.labelLarge!.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          onTap: quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(isEnabled ? 0.08 : 0.04),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: isEnabled ? AppColors.primary : AppColors.border(context),
        ),
      ),
    );
  }
}
