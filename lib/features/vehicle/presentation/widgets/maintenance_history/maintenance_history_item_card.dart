import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_entry.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceHistoryItemCard extends StatelessWidget {
  const MaintenanceHistoryItemCard({super.key, required this.entry});

  final MaintenanceHistoryEntry entry;

  static String _formatDate(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return AppBoxContainer(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40.w,
              child: Center(
                child: Image.asset(
                  AppAssets.maintenanceIcon,
                  width: 50.w,
                  height: 50.h,
                  color: AppColors.primary,
                ),
              ),
            ),
            VerticalDivider(
              color: AppColors.border(context), 
              thickness: 2.w,
              width: 20.w,
              indent: 5.h,
              endIndent: 5.h,
            ),
            Expanded(
              child: Column(
                children: [
                  AppInfoRow(
                    label: strings.description,
                    value: entry.description,
                    labelFontSize: 16, 
                    valueFontSize: 16,
                    leading: Icon(Icons.description_outlined, size: 18.sp, color: AppColors.primary),
                  ),
                  SizedBox(height: 8.h),
                  AppInfoRow(
                    label: strings.completed,
                    value: _formatDate(entry.date), 
                    leading: Icon(Icons.calendar_month_outlined, size: 18.sp, color: AppColors.primary),
                  ),
                  SizedBox(height: 8.h),
                  AppInfoRow(
                    label: strings.parts,
                    value: entry.part,
                    leading: Icon(Icons.settings_outlined, size: 18.sp, color: AppColors.primary),
                  ),
                  SizedBox(height: 8.h),
                  AppInfoRow(
                    label: strings.technician,
                    value: entry.technicianName,
                    leading: Icon(Icons.person_outline, size: 18.sp, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
