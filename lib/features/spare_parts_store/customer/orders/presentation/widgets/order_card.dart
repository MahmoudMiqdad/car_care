
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/order_status_badge.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.isCancelling,
    required this.onTap,
    required this.onCancel,
  });

  final OrderEntity order;
  final bool isCancelling;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
 

    final firstItemName = order.items.isNotEmpty
        ? order.items.first.product.name
        : l10n.noProductsAvailable; 
    final itemCount = order.items.length;
    final formattedPrice = order.totalPrice.toStringAsFixed(0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04), 
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.orderNumberLabel1,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 13.sp,
                            color: AppColors.textSecondary(context),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              order.shop.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelSmall!.copyWith(
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                OrderStatusBadge(status: order.status, label: order.statusText),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(color: AppColors.border(context), height: 1),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: AppColors.textPrimary(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (itemCount > 1) ...[
                        SizedBox(height: 2.h),
                        Text(
                       
                          l10n.plusMoreProductsLabel(itemCount - 1),
                          style: context.textTheme.labelSmall!.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.currencyFormat(formattedPrice),
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (order.createdAt != null)
                      Text(
                        order.createdAt!.toLocal().toString().substring(0, 10),
                        style: context.textTheme.labelSmall!.copyWith(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (order.canCancel) ...[
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: isCancelling
                    ? Center(
                        child: SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.red,
                          ),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: BorderSide(
                            color: AppColors.red.withValues(alpha: 0.5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        icon: Icon(Icons.cancel_outlined, size: 16.sp),
                        label: Text(
                          l10n.cancelRequestButton,
                          style: context.textTheme.labelSmall!.copyWith(
                            color: AppColors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
