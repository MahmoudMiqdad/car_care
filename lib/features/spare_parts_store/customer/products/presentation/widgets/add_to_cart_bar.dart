// شريط سفلي ثابت يحتوي على محدد الكمية وزر إضافة المنتج إلى السلة
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/quantity_selector.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToCartBar extends StatelessWidget {
  const AddToCartBar({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.totalPrice,
    required this.onQuantityChanged,
    required this.onAddToCart,
    this.isLoading = false,
  });

  final int quantity;
  final int maxQuantity;
  final double totalPrice;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 
    final formattedPrice = l10n.currencyFormat(totalPrice.toStringAsFixed(0));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06), 
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quantityLabel, 
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 4.h),
                QuantitySelector(
                  quantity: quantity,
                  maxQuantity: maxQuantity,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: (maxQuantity > 0 && !isLoading) ? onAddToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        l10n.addToCartWithPriceLabel(formattedPrice),
                        style: context.textTheme.labelLarge!.copyWith(color: AppColors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
