import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
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
    final currentLang = Localizations.localeOf(context).languageCode;
    final fontFamily = AppTypography.getFontFamily(currentLang);
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    final String brand = item.vehicleBrand ?? '';
    final String model = item.vehicleModel ?? '';
    final String createdAgoStr = item.createdAgo ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.carWashTeal, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.06),
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
                          label: l10n.sosRequestIdLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.editIcon,
                          ),
                          value: item.plateNumber ?? '-',
                        ),
                        RequestDetailRow(
                          label: l10n.sosRequestVehicleLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.sosRequestVehicleRowIcon,
                          ),
                          value: l10n.vehicleLabelWithParam(brand, model),
                        ),
                        RequestDetailRow(
                          label: l10n.sosRequestShortDescriptionLabel,
                          leading: const SosRequestRowAssetIcon(
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
            constraints: BoxConstraints(minHeight: 35.h),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            color: AppColors.carWashTeal,
            alignment: Alignment.center,
            child: Text(
              l10n.createdAgoLabel(createdAgoStr),
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: fontFamily,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
