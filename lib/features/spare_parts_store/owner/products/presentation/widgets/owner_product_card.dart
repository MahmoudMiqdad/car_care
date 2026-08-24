import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerProductCard extends StatelessWidget {
  const OwnerProductCard({
    super.key,
    required this.product,
    required this.isSaving,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductEntity product;
  final bool isSaving;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBusy = isSaving || isDeleting;
    final formattedPrice = product.finalPrice.toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: product.primaryImage != null
                    ? Image.network(
                        product.primaryImage!,
                        width: 56.w,
                        height: 56.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(context),
                      )
                    : _placeholder(context),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.currencyFormat(formattedPrice),
                      style: context.textTheme.labelMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      l10n.ownerStockCountLabel(product.stockQuantity),
                      style: context.textTheme.labelSmall!.copyWith(
                        color: product.stockQuantity > 0
                            ? AppColors.textSecondary(context)
                            : AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: AppColors.border(context), height: 1),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : onEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  icon: isSaving
                      ? SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(Icons.edit_outlined, size: 16.sp),
                  label: Text(
                    l10n.editButtonLabel,
                    style: context.textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: BorderSide(
                      color: AppColors.red.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  icon: isDeleting
                      ? SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.red,
                          ),
                        )
                      : Icon(Icons.delete_outline, size: 16.sp),
                  label: Text(
                    l10n.yesDeleteButton,
                    style: context.textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      color: AppColors.scaffoldBackground(context),
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.textSecondary(context),
        size: 24.sp,
      ),
    );
  }
}
