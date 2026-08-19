import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_details_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.vehicle});

  final RequestVehicleEntity vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return SosDetailsSectionCard(
      title: l10n.vehicleLabel, 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  buildVehicleLabel(
                    brand: vehicle.brand,
                    model: vehicle.model,
                    year: vehicle.year,
                  ),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                SosDetailsInfoRow(
                  iconAsset: AppAssets.plateNumberIcon,
                  label: l10n.plateNumberLabel, 
                  value: vehicle.plateNumber ?? '-',
                ),
                SosDetailsInfoRow(
                  iconAsset: AppAssets.technicianJobNotesIcon,
                  label: l10n.mileageLabel, 
                  value: vehicle.currentKm != null
                      ? l10n.kilometerCountLabel(vehicle.currentKm!) 
                      : '-',
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _VehicleAvatar(
            imageUrl: resolveMediaUrl(vehicle.image ?? vehicle.imagePath),
          ),
        ],
      ),
    );
  }
}


class _VehicleAvatar extends StatelessWidget {
  const _VehicleAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    if (url == null) return _placeholder();

    return ClipOval(
      child: Image.network(
        url,
        width: 80.r,
        height: 80.r,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return CircleAvatar(
      radius: 40.r,
      backgroundColor: AppColors.cardBackground(context),
      backgroundImage: const AssetImage(AppAssets.technicianJobVehicleIcon),
    );
  }
}
