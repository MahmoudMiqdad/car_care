import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/cubit/share_location_fuel_cubit.dart';
import 'package:car_care/features/fuel_provider/share_location_fuel/presentation/widgets/fuel_provider_map_widget.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class ProviderOrderDetailsPendingBanner extends StatelessWidget {
  const ProviderOrderDetailsPendingBanner({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.warning, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.hourglass_empty_rounded, color: AppColors.warning, size: 22.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderOrderDetailsOrderCard extends StatelessWidget {
  const ProviderOrderDetailsOrderCard({super.key, required this.order});
  final FuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vehicle = order.vehicle;
    final vehicleTitle = vehicle != null
        ? '${vehicle.brand ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'.trim()
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
          CircleAvatar(
            radius: 44.r,
            backgroundColor: AppColors.lightSurface,
            backgroundImage: const AssetImage(AppAssets.technicianJobVehicleIcon),
          ),
        ],
      ),
    );
  }
}

class ProviderOrderDetailsCustomerCard extends StatelessWidget {
  const ProviderOrderDetailsCustomerCard({super.key, required this.order});
  final FuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ownerName = order.vehicle?.ownerName ?? '-';
    final phone = order.fuelProvider?.phone ?? '-';

    return SosDetailsSectionCard(
      title: l10n.providerOrderDetailsCustomerSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ownerName,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Image.asset(
                AppAssets.iconPhoneCall,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.phone_in_talk_rounded,
                  size: 15.sp,
                  color: AppColors.carWashTeal,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                phone,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class ProviderOrderDetailsNotesCard extends StatelessWidget {
  const ProviderOrderDetailsNotesCard({
    super.key,
    required this.order,
  });

  final FuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final notes = order.notes ?? '-';

    return SosDetailsSectionCard(
      title: 'ملاحظات الطلب',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.NotesIcon, 
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.note_alt_outlined,
              size: 18.sp,
              color: AppColors.carWashTeal,
            ),
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              notes,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderOrderDetailsLocationCard extends StatelessWidget {
  const ProviderOrderDetailsLocationCard({
    super.key,
    required this.order,
  });

  final FuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLocation =
        order.deliveryLatitude != null && order.deliveryLongitude != null;
    final location = hasLocation
        ? LatLng(order.deliveryLatitude!, order.deliveryLongitude!)
        : const LatLng(33.3152, 44.3661);

    final isAccepted = order.status == 'accepted';

    return SosDetailsSectionCard(
      title: l10n.sosDetailsCurrentLocation,
      clipBody: true,
      child: GestureDetector(
        onTap: isAccepted ? () => _openFuelProviderMap(context) : null,
        child: Stack(
          children: [
            SizedBox(
              height: 180.h,
              child: IgnorePointer(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: location,
                    initialZoom: 14,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.car_care.app',
                    ),
                    if (hasLocation)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: location,
                            width: 24,
                            height: 24,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF45B733),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (isAccepted)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'اضغط لبدء التوجه ومشاركة موقعك',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openFuelProviderMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
          create: (_) => getIt<ShareFuelProviderLocationCubit>(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('التوجه للعميل'),
              backgroundColor: AppColors.carWashTeal,
              foregroundColor: Colors.white,
            ),
            body: FuelProviderMapWidget(
              orderId: order.id ?? 0,
              userLat: order.deliveryLatitude,
              userLng: order.deliveryLongitude,
            ),
          ),
        ),
      ),
    );
  }
}