import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/order_status_badge.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerOrderCard extends StatelessWidget {
  const OwnerOrderCard({super.key, required this.order, required this.onTap});

  final OrderEntity order;
  final VoidCallback onTap;

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
              children: [
                Expanded(
                  child: Text(
                    l10n.orderNumberLabel(order.id.toString()),
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                OrderStatusBadge(
                  status: order.status,
                  label: orderStatusLabel(
                    context,
                    order.status,
                    fallback: order.statusText,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currencyFormat(formattedPrice),
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (order.createdAt != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        order.createdAt!.toLocal().toString().substring(0, 10),
                        style: context.textTheme.labelSmall!.copyWith(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
