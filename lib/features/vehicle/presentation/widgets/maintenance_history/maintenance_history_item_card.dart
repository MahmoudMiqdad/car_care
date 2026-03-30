import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_text_styles.dart';
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/arabic_formatting.dart';
import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceHistoryItemCard extends StatelessWidget {
  const MaintenanceHistoryItemCard({
    super.key,
    required this.entry,
  });

  final MaintenanceHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42.w,
            child: Image.asset(
              AppAssets.maintenanceIcon,
              width: 27.w,
              height: 27.h,
              color: AppColors.primary,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 2.w,
            height: 112.h,
            color: AppColors.primary,
            margin: EdgeInsetsDirectional.only(end: 10.w),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledLine(
                  label: 'وصف:',
                  value: entry.description,
                  icon: Icons.description_outlined,
                  isTitle: true,
                ),
                SizedBox(height: 4.h),
                LabeledLine(
                  label: 'التاريخ:',
                  value: ArabicFormatting.formatDateSlashedEastern(entry.date),
                  icon: Icons.calendar_month_outlined,
                ),
                SizedBox(height: 4.h),
                LabeledLine(
                  label: 'القطع:',
                  value: entry.part,
                  icon: Icons.settings,
                ),
                SizedBox(height: 4.h),
                LabeledLine(
                  label: 'اسم الفني:',
                  value: entry.technicianName,
                  icon: Icons.account_circle_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledLine extends StatelessWidget {
  const LabeledLine({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isTitle = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: isTitle ? AppTextStyles.font20BlackBold : AppTextStyles.font18BlackBold,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            value,
            style: isTitle ? AppTextStyles.font20BlackBold : AppTextStyles.font18BlackSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}