// لون وشارة حالة الطلب — مكوّن مشترك بين واجهتَي العميل والمالك حتى لا
// تختلف الألوان/الأسماء بين الجهتين. rejected حالة مستقلة عن cancelled
// (رفض المالك للطلب أثناء pending وليس إلغاء العميل).
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color orderStatusColor(String status) => switch (status) {
  'pending' => AppColors.warning,
  'accepted' => AppColors.info,
  'processing' => AppColors.info,
  'out_for_delivery' => AppColors.primary,
  'delivered' => AppColors.success,
  'cancelled' => AppColors.error,
  'rejected' => AppColors.error,
  _ => AppColors.lightTextSecondary,
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
    final color = orderStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
