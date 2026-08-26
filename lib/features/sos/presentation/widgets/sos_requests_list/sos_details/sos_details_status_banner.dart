import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosDetailsStatusBanner extends StatelessWidget {
  const SosDetailsStatusBanner({super.key, required this.label, this.status});

  final String label;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final style = status == null
        ? SosRequestStatusBadgeStyle.softSuccess
        : sosRequestStatusBadgeStyleFor(status);
    final isError = style == SosRequestStatusBadgeStyle.softError;
    final isNeutral = style == SosRequestStatusBadgeStyle.outlineOnWhite;
    final color = isError
        ? context.colorScheme.error
        : isNeutral
        ? AppColors.carWashTeal
        : AppColors.successColor(context);
    final surface = isError
        ? color.withValues(alpha: 0.12)
        : isNeutral
        ? AppColors.cardBackground(context)
        : color.withValues(alpha: 0.12);
    final icon = isError
        ? Icons.cancel_outlined
        : isNeutral
        ? Icons.schedule_outlined
        : Icons.check_circle_outline;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: Directionality.of(context),
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
