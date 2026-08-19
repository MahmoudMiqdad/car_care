import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuelOrderDetailsOrderCard extends StatelessWidget {
  const FuelOrderDetailsOrderCard({super.key, required this.order});

  final UserFuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vehicle = order.vehicle;
    final vehicleTitle = vehicle != null
        ? '${vehicle.brand ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'
              .trim()
        : '-';

    return SosDetailsSectionCard(
      title: l10n.sosDetailsRequestData,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  vehicleTitle,
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                SosDetailsInfoRow(
                  iconAsset: AppAssets.plateNumberIcon,
                  label: l10n.sosDetailsPlateNumberLabel,
                  value: vehicle?.plateNumber ?? '-',
                ),
                SosDetailsInfoRow(
                  iconAsset: AppAssets.serviceFuel,
                  label: l10n.fuel,
                  value: '${order.fuelType ?? '-'} - ${order.amount ?? 0} لتر',
                ),
                SosDetailsInfoRow(
                  iconAsset: AppAssets.fuelOrderMoneyIcon,
                  label: l10n.price,
                  value: order.totalPrice ?? '-',
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _FuelOrderVehicleAvatar(
            imageUrl: resolveMediaUrl(vehicle?.image ?? vehicle?.imagePath),
          ),
        ],
      ),
    );
  }
}

/// Shows the real vehicle image from the API — same resolveMediaUrl()
/// helper and network-with-fallback pattern already used successfully for
/// the maintenance request details' vehicle card. Falls back to the
/// placeholder asset only when there is no image or it fails to load.
class _FuelOrderVehicleAvatar extends StatelessWidget {
  const _FuelOrderVehicleAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    // 💡 قمنا بنقل دالة الـ placeholder إلى هنا لتصبح دالة داخلية ترى الـ context تلقائياً
    Widget placeholder() {
      return CircleAvatar(
        radius: 44.r,
        backgroundColor: AppColors.cardBackground(context), // سيعمل الآن بشكل صحيح تماماً
        backgroundImage: const AssetImage(AppAssets.technicianJobVehicleIcon),
      );
    }

    if (url == null) return placeholder();

    return ClipOval(
      child: Image.network(
        url,
        width: 88.r,
        height: 88.r,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder(),
      ),
    );
  }
}
