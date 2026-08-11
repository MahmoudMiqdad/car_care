import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/constants/app_assets.dart';

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/sos/domain/entities/sos_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/request_detail_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SosRequestCard extends StatelessWidget {
  const SosRequestCard({super.key, required this.item});

  final SosEntity item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.carWashTeal, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RequestDetailRow(
                          label: l10n.sosRequestIdLabel,
                          leading: SosRequestRowAssetIcon(
                            assetPath: AppAssets.editIcon,
                          ),
                          value: item.plateNumber.toString(),
                        ),
                        RequestDetailRow(
                          label: l10n.sosRequestVehicleLabel,
                          leading: SosRequestRowAssetIcon(
                            assetPath: AppAssets.sosRequestVehicleRowIcon,
                          ),
                          value:
                              '${item.vehicleBrand ?? ''} ${item.vehicleModel ?? ''}',
                        ),
                        RequestDetailRow(
                          label: l10n.sosRequestShortDescriptionLabel,
                          leading: SosRequestRowAssetIcon(
                            assetPath: AppAssets.technicianJobNotesIcon,
                          ),
                          multilineBelow: item.description,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(width: 1, color: AppColors.carWashTeal),
                  SizedBox(width: 12.w),
                  // Real backend status only — no static three-state list.
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SosRequestStatusBadge(
                        label: item.statusText?.trim().isNotEmpty == true
                            ? item.statusText!
                            : '-',
                        style: sosRequestStatusBadgeStyleFor(item.status),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                AppButton(
                  onPressed: () {
                    context.pushNamed(
                      'sosDetails',
                      pathParameters: {'id': item.id.toString()},
                    );
                  },
                  text: l10n.sosRequestViewDetails,
                  backgroundColor: AppColors.accent,
                  textColor: AppColors.white,
                  borderRadius: 24.r,
                  height: 50.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 35.h,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            color: AppColors.carWashTeal,
            child: Text(
              'created Ago ${item.createdAgo!}',
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
