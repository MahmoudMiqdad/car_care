import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/requests_form_card.dart';
import 'package:car_care/l10n.dart'; // 🎯 استيراد امتداد l10n للترجمة الديناميكية
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferredDateSection extends StatelessWidget {
  const PreferredDateSection({
    super.key,
    required this.cardRadius,
    required this.formattedDate,
    required this.onPickDate,
  });

  final double cardRadius;
  final DateTime formattedDate;
  final VoidCallback onPickDate;

  static String _formatDate(DateTime d) =>
      '${d.year}/${d.month}/${d.day}  ';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 
  
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return RequestsFormCard(
      cardRadius: cardRadius,
      title: l10n.selectPreferredDateTitle, 
      icon: Icons.calendar_today,
      iconColor: AppColors.primary,
      child: InkWell(
        onTap: onPickDate,
        borderRadius: BorderRadius.circular(2.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(formattedDate),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context).withValues(alpha: 0.85),
                ),
              ),
              Icon(
                isRtl ? Icons.chevron_left : Icons.chevron_right, 
                color: AppColors.primary, 
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
