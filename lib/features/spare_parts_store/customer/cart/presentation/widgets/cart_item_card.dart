import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/entities/cart_item_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.isQuantityUpdating,
    required this.isDeleting,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  final CartItemEntity item;
  final bool isQuantityUpdating;
  final bool isDeleting;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final imageUrl =
        product.primaryImage ??
        (product.images.isNotEmpty ? product.images.first : null);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: _ItemImage(imageUrl: imageUrl),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: AppColors.textPrimary(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _CartDeleteButton(isDeleting: isDeleting, onTap: onDelete),
                  ],
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
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CartQuantityControls(
                      quantity: item.quantity,
                      maxQuantity: product.stockQuantity,
                      isUpdating: isQuantityUpdating,
                      onChanged: onQuantityChanged,
                    ),
                    Text(
                      '${item.subtotal.toStringAsFixed(0)} ${context.l10n.currencySyp}',
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartDeleteButton extends StatelessWidget {
  const _CartDeleteButton({required this.isDeleting, required this.onTap});

  final bool isDeleting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDeleting ? null : onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: isDeleting
                ? SizedBox(
                    width: 16.sp,
                    height: 16.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.error,
                    ),
                  )
                : Icon(
                    Icons.delete_outline,
                    size: 20.sp,
                    color: context.colorScheme.error,
                  ),
          ),
        ),
      ),
    );
  }
}

class _CartQuantityControls extends StatelessWidget {
  const _CartQuantityControls({
    required this.quantity,
    required this.maxQuantity,
    required this.isUpdating,
    required this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final bool isUpdating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CartQtyButton(
          icon: Icons.remove,
          onTap: (!isUpdating && quantity > 1)
              ? () => onChanged(quantity - 1)
              : null,
        ),
        SizedBox(
          width: 28.w,
          height: 28.w,
          child: isUpdating
              ? Center(
                  child: SizedBox(
                    width: 14.sp,
                    height: 14.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Text(
                      '$quantity',
                      key: ValueKey(quantity),
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ),
        ),
        _CartQtyButton(
          icon: Icons.add,
          onTap: (!isUpdating && quantity < maxQuantity)
              ? () => onChanged(quantity + 1)
              : null,
        ),
      ],
    );
  }
}

class _CartQtyButton extends StatelessWidget {
  const _CartQtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return SizedBox(
      width: 32.w,
      height: 32.w,
      child: Material(
        color: AppColors.primary.withOpacity(isEnabled ? 0.08 : 0.04),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: 16.sp,
              color: isEnabled ? AppColors.primary : AppColors.border(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        width: 72.w,
        height: 72.w,
        color: context.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.build_circle_outlined,
          size: 28.sp,
          color: AppColors.primary.withOpacity(0.4),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: 72.w,
      height: 72.w,
      fit: BoxFit.cover,
      placeholder: (context, url) => ColoredBox(color: AppColors.secondary),
      errorWidget: (context, url, error) => Container(
        color: context.colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          size: 22.sp,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }
}
