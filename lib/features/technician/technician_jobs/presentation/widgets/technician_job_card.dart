import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TechnicianJobCardStatus { waiting, rejected }

class TechnicianJobUiModel {
  const TechnicianJobUiModel({
    required this.status,
    required this.description,
    required this.customerName,
    required this.vehicle,
    required this.appointmentDate,
    required this.priceOffer,
    this.statusLabel,
  });

  final TechnicianJobCardStatus status;
  final String description;
  final String customerName;
  final String vehicle;
  final String appointmentDate;

  final String? priceOffer;

  final String? statusLabel;
}

class TechnicianJobCard extends StatelessWidget {
  const TechnicianJobCard({
    super.key,
    required this.job,
    this.rawStatus,
    this.isBusy = false,
    this.onStart,
    this.onComplete,
  });

  final TechnicianJobUiModel job;

  final String? rawStatus;
  final bool isBusy;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

 @override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  final bool isWaiting = job.status == TechnicianJobCardStatus.waiting;
  
  final Color statusBg = isWaiting 
      ? AppColors.info.withValues(alpha: 0.12) 
      : AppColors.red.withValues(alpha: 0.12);
  final Color statusColor = isWaiting ? AppColors.info : AppColors.red;
  
  final double localLabelSize = 17.sp;
  final double localValueSize = 16.sp;

  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cardBody(context, isWaiting, statusBg, statusColor, localLabelSize, localValueSize),
        _statusAction(context),
      ],
    ),
  );
}

Widget _statusAction(BuildContext context) {
  final l10n = context.l10n;
  final status = rawStatus?.toLowerCase();
  final isAssigned = status == 'assigned';
  final isInProgress = status == 'in_progress' || status == 'in-progress';

  if (!isAssigned && !isInProgress) return const SizedBox.shrink();

  final onPressed = isAssigned ? onStart : onComplete;

  return Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: SizedBox(
      height: 44.h,
      child: ElevatedButton(
        onPressed: isBusy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAssigned ? AppColors.carWashTeal : AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.border(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          isBusy
              ? l10n.updatingProgress
              : (isAssigned ? l10n.startWorkButtonLabel : l10n.endWorkButtonLabel),
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}

Widget _cardBody(
  BuildContext context,
  bool isWaiting,
  Color statusBg,
  Color statusColor,
  double localLabelSize,
  double localValueSize,
) {
  final l10n = context.l10n;

  return ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppInfoRow(
                    label: l10n.descriptionLabel,
                    value: job.description,
                    labelFontSize: localLabelSize,
                    valueFontSize: localValueSize,
                    leading: _rowAsset(AppAssets.technicianJobNotesIcon),
                  ),
                  AppInfoRow(
                    label: l10n.clientLabel,
                    value: job.customerName,
                    labelFontSize: localLabelSize,
                    valueFontSize: localValueSize,
                    leading: _rowAsset(AppAssets.technicianJobProfileIcon),
                  ),
                  AppInfoRow(
                    label: l10n.vehicleLabel,
                    value: job.vehicle,
                    labelFontSize: localLabelSize,
                    valueFontSize: localValueSize,
                    leading: Icon(Icons.directions_car_filled_rounded, size: 20.sp, color: AppColors.primary),
                  ),
                  AppInfoRow(
                    label: l10n.appointmentLabel,
                    value: job.appointmentDate,
                    labelFontSize: localLabelSize,
                    valueFontSize: localValueSize,
                    leading: _rowAsset(AppAssets.calendarIcon),
                  ),
                  if (job.priceOffer != null)
                    AppInfoRow(
                      label: l10n.quotationPriceLabel,
                      value: job.priceOffer!,
                      labelFontSize: localLabelSize,
                      valueFontSize: localValueSize,
                      leading: Icon(Icons.monetization_on_rounded, size: 20.sp, color: AppColors.primary),
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
                  if (isWaiting)
                    Image.asset(
                      AppAssets.technicianJobTimeIcon,
                      width: 45.sp,
                      height: 45.sp,
                      color: statusColor,
                    )
                  else
                    Container(
                      width: 45.r,
                      height: 45.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: statusColor, width: 2.5),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: statusColor,
                        size: 32.sp,
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Text(
                    job.statusLabel ?? (isWaiting ? l10n.pending : l10n.rejectedStatusLabel),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    errorBuilder: (_, _, _) => Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
  );
}
}