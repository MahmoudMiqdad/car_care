import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_tracking_cubit/user_fuel_tracking_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/user_fuel_tracking_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class FuelOrderDetailsLocationCard extends StatelessWidget {
  const FuelOrderDetailsLocationCard({super.key, required this.order});

  final UserFuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLocation =
        order.deliveryLatitude != null && order.deliveryLongitude != null;
    final location = hasLocation
        ? LatLng(order.deliveryLatitude!, order.deliveryLongitude!)
        : const LatLng(33.3152, 44.3661);

    final canTrack =
        order.status == 'accepted' || order.status == 'in_progress';

    return SosDetailsSectionCard(
      title: l10n.sosDetailsCurrentLocation,
      clipBody: true,
      child: GestureDetector(
        onTap: canTrack ? () => _openTrackingMap(context) : null,
        child: SizedBox(
          height: 180.h,
          child: Stack(
            children: [
              IgnorePointer(
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
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (canTrack)
                PositionedDirectional(
                  bottom: 8.h,
                  start: 8.w,
                  end: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.54),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      l10n.tapToTrackFuelProviderLive,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white, fontSize: 12.sp),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTrackingMap(BuildContext context) {
    final l10n = context.l10n;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
          create: (_) => getIt<UserFuelTrackingCubit>(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.trackFuelProviderTitle),
              backgroundColor: AppColors.carWashTeal,
              foregroundColor: AppColors.white,
            ),
            body: UserFuelTrackingMapWidget(
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
