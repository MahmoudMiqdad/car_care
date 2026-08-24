import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/service/pusher_service.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:car_care/features/sos/presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class SosDetailsLocationCard extends StatelessWidget {
  const SosDetailsLocationCard({
    super.key,
    required this.sosId,
    this.lat,
    this.lng,
  });

  final int sosId;
  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLocation = lat != null && lng != null;
    final location = hasLocation
        ? LatLng(lat!, lng!)
        : const LatLng(33.3152, 44.3661);

    return SosDetailsSectionCard(
      title: l10n.sosDetailsCurrentLocation,
      bodyHeight: 200.h,
      clipBody: true,
      child: Stack(
        fit: StackFit.expand,
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.car_care.app',
                ),
                if (hasLocation)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: location,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.red,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showSosTrackingSheet(BuildContext context, int sosId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => TrackingCubit(getIt<ISosRepository>(), PusherService()),
      child: _TrackingSheet(sosId: sosId),
    ),
  );
}

class _TrackingSheet extends StatelessWidget {
  final int sosId;

  const _TrackingSheet({required this.sosId});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.red),
                SizedBox(width: 8.w),
                Text(
                  l10n.trackTechnician,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          Expanded(child: SosMapWidget(sosId: sosId)),
        ],
      ),
    );
  }
}
