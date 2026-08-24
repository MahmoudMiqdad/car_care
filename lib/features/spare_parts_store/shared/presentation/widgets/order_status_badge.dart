
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color orderStatusColor(BuildContext context, String status) => switch (status) {
  'pending' => AppColors.warningColor(context),
  'accepted' => context.colorScheme.primary,
  'processing' => context.colorScheme.primary,
  'out_for_delivery' => context.colorScheme.primary,
  'delivered' => AppColors.successColor(context),
  'cancelled' => context.colorScheme.error,
  'rejected' => context.colorScheme.error,
  _ => AppColors.textSecondary(context),
};

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
