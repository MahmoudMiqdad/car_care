// بطاقة متجر تُستخدم داخل شاشة قائمة المتاجر
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_attribute_chip.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.shop, required this.onVisit});

  final ShopEntity shop;
  final VoidCallback onVisit;

  @override
  Widget build(BuildContext context) {
    final previewTypes = shop.businessTypes.take(2).toList();

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onVisit,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (shop.city != null) ...[
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14.sp,
                                color: AppColors.lightTextSecondary,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                shop.city!,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  StoreStatusBadge(isActive: shop.isActive),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.lightTextSecondary.withOpacity(0.6),
                  ),
                ],
              ),
              if (previewTypes.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: previewTypes
                      .map(
                        (value) => StoreAttributeChip(
                          label: value,
                          type: StoreAttributeType.businessType,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
