import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.job, this.onTap});

  final DataEntity job;
  final VoidCallback? onTap;

  static String _formatDate(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLang = Localizations.localeOf(context).languageCode;
    final fontFamily = AppTypography.getFontFamily(currentLang);

    final bool isWaiting = job.status == 'waiting';
    final bool isCompleted = job.status == 'completed';
    final bool isAccepted = job.status == 'quotation_accepted';

    final Color statusBg = isWaiting
        ? AppColors.info.withValues(alpha: 0.12)
        : (isCompleted || isAccepted
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.red.withValues(alpha: 0.12));

    final Color statusColor = isWaiting
        ? AppColors.info
        : (isCompleted || isAccepted
            ? AppColors.success
            : AppColors.red);

    final IconData statusIcon = isWaiting
        ? Icons.hourglass_empty_rounded
        : isAccepted
            ? Icons.task_alt_rounded
            : isCompleted
                ? Icons.task_alt_rounded
                : Icons.cancel_outlined;

    final String descriptionStr = job.description?.toString() ?? '';
    final String vehicleBrand = job.vehicle?.brand ?? '';
    final String vehicleModel = job.vehicle?.model ?? '';
    final String statusTextStr = job.statusText ?? '-';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.cardBackground(context),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ⬅️ بلا getDynamicFontSize ولا تحجيم يدوي — AppInfoRow
                        // بتطبق .sp بنفسها، فبنبعتلها الرقم التصميمي الخام بس.
                        AppInfoRow(
                          label: l10n.descriptionLabel,
                          value: descriptionStr,
                          labelFontSize: 16,
                          valueFontSize: 15,
                          leading: _rowAsset(AppAssets.technicianJobNotesIcon),
                        ),
                        AppInfoRow(
                          label: l10n.vehicleLabel,
                          value: l10n.vehicleLabelWithParam(vehicleBrand, vehicleModel),
                          labelFontSize: 16,
                          valueFontSize: 15,
                          leading: Icon(
                            Icons.directions_car_filled_rounded,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        AppInfoRow(
                          label: l10n.appointmentLabel,
                          value: job.preferredDate != null ? _formatDate(job.preferredDate!) : '-',
                          labelFontSize: 16,
                          valueFontSize: 15,
                          leading: _rowAsset(AppAssets.calendarIcon),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  child: Container(
                    color: statusBg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 45.r,
                          height: 45.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor, width: 2.5),
                          ),
                          child: Icon(statusIcon, color: statusColor, size: 28.sp),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              statusTextStr,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                fontFamily: fontFamily,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowAsset(String path) {
    return Image.asset(
      path,
      width: 20.sp,
      height: 20.sp,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
    );
  }
}