import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final showDiscount = product.discountPrice != null && product.hasDiscount;

    final tags = <Widget>[
      _InfoChip(
        label: l10n.productConditionLabel(
          product.isNew ? l10n.conditionNew : l10n.conditionUsed,
        ),
        backgroundColor: AppColors.accent.withValues(alpha: 0.14),
        textColor: AppColors.accent,
      ),
      if (product.partCategoryName != null)
        _InfoChip(
          label: l10n.productCategoryLabel(product.partCategoryName!),
          backgroundColor: AppColors.secondary,
          textColor: AppColors.textPrimary(context),
        ),
      if (product.carBrandName != null)
        _InfoChip(
          label: l10n.productCarBrandLabel(product.carBrandName!),
          backgroundColor: context.colorScheme.surfaceContainer,
          textColor: AppColors.textSecondary(context),
          borderColor: AppColors.border(context),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: context.textTheme.headlineMedium!.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(spacing: 8.w, runSpacing: 6.h, children: tags),
        SizedBox(height: 16.h),
        Text(
          l10n.currencyFormat(product.finalPrice.toStringAsFixed(0)),
          style: context.textTheme.headlineLarge!.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (showDiscount) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                l10n.currencyFormat(product.price.toStringAsFixed(0)),
                style: context.textTheme.bodyMedium!.copyWith(
                  color: AppColors.textSecondary(context),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.discountPercentLabel(product.discountPercent.toString()),
                style: context.textTheme.labelSmall!.copyWith(
                  color: AppColors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 10.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: product.stockQuantity > 0
                    ? AppColors.green
                    : AppColors.red,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              product.stockQuantity > 0
                  ? l10n.inStockWithCountLabel(product.stockQuantity)
                  : l10n.outOfStockStatus,
              style: context.textTheme.labelSmall!.copyWith(
                color: product.stockQuantity > 0
                    ? AppColors.green
                    : AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Divider(color: AppColors.border(context), height: 1),
        SizedBox(height: 14.h),
        Text(
          l10n.descriptionLabel,
          style: context.textTheme.labelLarge!.copyWith(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          product.description,
          style: context.textTheme.bodyMedium!.copyWith(
            color: AppColors.textSecondary(context),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
