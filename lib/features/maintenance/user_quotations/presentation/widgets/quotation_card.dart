import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/request_detail_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuotationCard extends StatelessWidget {
  const QuotationCard({super.key, required this.quotation, this.onTap});

  final QuotationEntity quotation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.carWashTeal, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RequestDetailRow(
                          label: l10n.technicianLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.technicianJobVehicleIcon,
                          ),
                          value: quotation.technician.name,
                        ),
                        RequestDetailRow(
                          label: l10n.price,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.fuelOrderMoneyIcon,
                          ),
                          value: quotation.priceFormatted,
                        ),
                        RequestDetailRow(
                          label: l10n.repairDurationLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.calendarIcon,
                          ),
                          value: l10n.durationInDays(quotation.estimatedDays),
                        ),
                        RequestDetailRow(
                          label: l10n.partsIncludedLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.NotesIcon,
                          ),
                          value: quotation.partsIncluded ? l10n.yes : l10n.no,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(width: 1, color: AppColors.carWashTeal),
                  SizedBox(width: 12.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SosRequestStatusBadge(
                        label: maintenanceRequestStatusLabel(
                          context,
                          quotation.status,
                          fallback: quotation.statusText,
                        ),
                        style: SosRequestStatusBadgeStyle.softSuccess,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: AppButton(
              onPressed: onTap ?? () {},
              text: l10n.sosRequestViewDetails,
              textColor: AppColors.white,
              borderRadius: 15.r,
              height: 45.h,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 27.h,
            alignment: Alignment.center,
            color: AppColors.carWashTeal,
            child: Text(
              quotation.createdAgo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
