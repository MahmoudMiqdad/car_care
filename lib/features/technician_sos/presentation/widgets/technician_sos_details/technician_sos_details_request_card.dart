import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosTechnicianDetailsRequestCard extends StatelessWidget {
  const SosTechnicianDetailsRequestCard({
    super.key,
    required this.vehicleTitle,
    required this.plateNumber,
    required this.technicianName,
    required this.description,
    this.vehicleImageUrl,
  });

  final String vehicleTitle;
  final String plateNumber;
  final String technicianName;
  final String description;

  /// Real vehicle image from the API; null falls back to a placeholder icon.
  final String? vehicleImageUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SosDetailsSectionCard(
      title: l10n.sosDetailsRequestData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vehicleImageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                vehicleImageUrl!,
                height: 140.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _imagePlaceholder(),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          Text(
            vehicleTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          SosDetailsInfoRow(
            iconAsset: AppAssets.plateNumberIcon,
            label: l10n.sosDetailsPlateNumberLabel,
            value: plateNumber,
          ),
          SosDetailsInfoRow(
            iconAsset: AppAssets.reviewerProfilePicture100,
            label: l10n.sosDetailsTechnicianLabel,
            value: technicianName,
          ),
          SosDetailsInfoRow(
            iconAsset: AppAssets.editIcon,
            label: l10n.sosDetailsDescriptionLabel,
            value: description,
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 140.h,
      width: double.infinity,
      color: const Color(0xFFF5F7F9),
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: 48.sp,
        color: AppColors.primary,
      ),
    );
  }
}
