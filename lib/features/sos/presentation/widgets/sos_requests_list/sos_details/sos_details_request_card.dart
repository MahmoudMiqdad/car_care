import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosDetailsRequestCard extends StatelessWidget {
  const SosDetailsRequestCard({
    super.key,
    required this.vehicleTitle,
    required this.plateNumber,
    required this.technicianName,
    required this.description,
  });

  final String vehicleTitle;
  final String plateNumber;
  final String technicianName;
  final String description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SosDetailsSectionCard(
      title: l10n.sosDetailsRequestData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            vehicleTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: context.colorScheme.onSurface,
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
}
