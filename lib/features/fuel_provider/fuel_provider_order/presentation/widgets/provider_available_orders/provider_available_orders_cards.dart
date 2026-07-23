import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/request_detail_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_status_badge.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderAvailableOrderCard extends StatelessWidget {
  const ProviderAvailableOrderCard({
    super.key,
    required this.order,
    this.onViewDetails,
  });

  final FuelOrderEntity order;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    final vehicleText = order.vehicle != null
        ? '${order.vehicle!.brand ?? ''} ${order.vehicle!.model ?? ''}'.trim()
        : '-';
    final fuelText = '${order.fuelType ?? '-'} - ${order.amount ?? 0} لتر';
    final notesText = (order.notes == null || order.notes!.isEmpty)
        ? l10n.providerAvailableOrderNoNotes
        : order.notes!;
    final dateText = order.scheduledTime ?? order.createdAt ?? '-';

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
                          label: l10n.providerEditProfileAddressLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.iconLocationPin,
                          ),
                          value: order.deliveryAddress ?? '-',
                        ),
                        RequestDetailRow(
                          label: l10n.sosRequestVehicleLabel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.sosRequestVehicleRowIcon,
                          ),
                          value: vehicleText,
                        ),
                        RequestDetailRow(
                          label: l10n.fuel,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.serviceFuel,
                          ),
                          value: fuelText,
                        ),
                        RequestDetailRow(
                          label: l10n.price,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.fuelOrderMoneyIcon,
                          ),
                          value: order.totalPrice ?? '-',
                        ),
                        RequestDetailRow(
                          label: l10n.notes,
                          leading: const SosRequestRowAssetIcon(
                            assetPath: AppAssets.fuelSosCreateNotesIcon,
                          ),
                          value: notesText,
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
                        label: order.statusText ?? '-',
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
              onPressed: onViewDetails ?? () {},
              text: l10n.sosRequestViewDetails,
              backgroundColor: AppColors.orange,
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
              dateText,
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