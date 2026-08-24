import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final ProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final imageUrl =
        product.primaryImage ??
        (product.images.isNotEmpty ? product.images.first : null);
    final conditionColor = product.isNew ? AppColors.green : AppColors.accent;

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(imageUrl: imageUrl),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  if (product.partCategoryName != null ||
                      product.carBrandName != null) ...[
                    SizedBox(height: 3.h),
                    Text(
                      [
                        if (product.partCategoryName != null)
                          product.partCategoryName,
                        if (product.carBrandName != null) product.carBrandName,
                      ].join(' | '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall!.copyWith(
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.currencyFormat(
                            product.finalPrice.toStringAsFixed(0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        product.isNew ? l10n.conditionNew : l10n.conditionUsed,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: conditionColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: product.stockQuantity > 0
                              ? AppColors.green
                              : AppColors.red,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        product.stockQuantity > 0
                            ? l10n.inStockStatus
                            : l10n.outOfStockStatus,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: product.stockQuantity > 0
                              ? AppColors.green
                              : AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        width: double.infinity,
        height: 110.h,
        color: context.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.build_circle_outlined,
          size: 36.sp,
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: double.infinity,
      height: 110.h,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          ColoredBox(color: context.colorScheme.surfaceContainerHighest),
      errorWidget: (context, url, error) => Container(
        color: context.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          size: 28.sp,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }
}
