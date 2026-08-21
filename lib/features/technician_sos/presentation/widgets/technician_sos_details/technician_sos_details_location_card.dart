// ignore_for_file: deprecated_member_use

import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_section_card.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_track_chip.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
class SosTechnicianDetailsLocationCard extends StatelessWidget {
  const SosTechnicianDetailsLocationCard({
    super.key,
    required this.sosId,
    this.lat,
    this.lng,
    this.isAccepted = false,
  });

  final int sosId;
  final double? lat;
  final double? lng;
  final bool isAccepted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLocation = lat != null && lng != null;
    final location =
        hasLocation ? LatLng(lat!, lng!) : const LatLng(33.3152, 44.3661);

    return SosTechnicianDetailsSectionCard(
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
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          if (isAccepted)
            PositionedDirectional(
              start: 12.w,
              bottom: 12.h,
              child: SosTechnicianDetailsTrackChip(
                label: l10n.startHeadingButtonLabel,
                onTap: () => _openTechnicianMap(context),
              ),
            ),
          if (!isAccepted)
            PositionedDirectional(
              bottom: 12.h,
              start: 12.w,
              end: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.54),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  l10n.acceptRequestToNavigateHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.white, fontSize: 12.sp),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openTechnicianMap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ShareTechnicianLocationSosCubit>(),
        child: _TechnicianNavigationSheet(
          sosId: sosId,
          userLat: lat,
          userLng: lng,
        ),
      ),
    );
  }
}

class _TechnicianNavigationSheet extends StatelessWidget {
  final int sosId;
  final double? userLat;
  final double? userLng;

  const _TechnicianNavigationSheet({
    required this.sosId,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.navigation, color: AppColors.carWashTeal),
                SizedBox(width: 8.w),
                Text(
                  l10n.headingToClientTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
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
          Expanded(
            child: TechnicianMapWidget(
              sosId: sosId,
              userLat: userLat,
              userLng: userLng,
            ),
          ),
        ],
      ),
    );
  }
}
