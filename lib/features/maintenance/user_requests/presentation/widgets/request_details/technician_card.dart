import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class TechnicianCard extends StatelessWidget {
  const TechnicianCard({
    super.key,
    required this.technician,
    required this.onMapTap,
  });

  final AssignedTechnicianEntity technician;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = technician.currentLocation;

    return SosDetailsSectionCard(
      title: l10n.technicianLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            technician.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          SosDetailsInfoRow(
            iconAsset: AppAssets.iconPhoneCall,
            label: l10n.profileWasherFieldPhone,
            value: technician.phone,
          ),
          SosDetailsInfoRow(
            iconAsset: AppAssets.technicianJobNotesIcon,
            label: l10n.specializationLabel,
            value: technician.specialization,
          ),
          SosDetailsInfoRow(
            iconAsset: AppAssets.calendarIcon,
            label: l10n.experienceYearsLabel,

            value: l10n.durationInYears(technician.experienceYears),
          ),
          if (location != null) ...[
            SizedBox(height: 12.h),
            Text(
              l10n.technicianLocationTitle,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            _TechnicianMapPreview(location: location, onTap: onMapTap),
          ],
        ],
      ),
    );
  }
}

class _TechnicianMapPreview extends StatelessWidget {
  const _TechnicianMapPreview({required this.location, required this.onTap});

  final RequestCurrentLocationEntity location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          height: 160.h,
          width: double.infinity,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(location.lat, location.lng),
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.car_care.app',
                    maxNativeZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(location.lat, location.lng),
                        width: 36.w,
                        height: 36.h,
                        child: Icon(
                          Icons.location_pin,
                          color: AppColors.carWashTeal,
                          size: 36.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 8.h,

                left: Directionality.of(context) == TextDirection.rtl
                    ? null
                    : 8.w,
                right: Directionality.of(context) == TextDirection.rtl
                    ? 8.w
                    : null,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainer.withValues(
                      alpha: 0.85,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.fullscreen,
                    color: AppColors.carWashTeal,
                    size: 20.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
