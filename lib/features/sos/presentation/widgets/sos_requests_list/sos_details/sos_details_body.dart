import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/sos/domain/entities/sos_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_location_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_request_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SosDetailsBody extends StatelessWidget {
  const SosDetailsBody({
    super.key,
    required this.vehicleTitle,
    required this.plateNumber,
    required this.technicianName,
    required this.description,
    this.onTrackTapped,
    this.onCancelTapped,
    required this.sos,
  });
  final SosEntity sos;
  final String vehicleTitle;
  final String plateNumber;
  final String technicianName;
  final String description;
  final VoidCallback? onTrackTapped;
  final VoidCallback? onCancelTapped;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppConstants.pageHorizontal,
          16.h,
          AppConstants.pageHorizontal,
          24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SosDetailsStatusBanner(label: sos.statusText!),
            SizedBox(height: 14.h),
            SosDetailsRequestCard(
              vehicleTitle: vehicleTitle,
              plateNumber: plateNumber,
              technicianName: technicianName,
              description: description,
            ),
            SizedBox(height: 14.h),
            SosDetailsLocationCard(
              sosId: sos.id!,
              lat: sos.lat, // موقع الـ SOS
              lng: sos.lng,
            ),
            SizedBox(height: 22.h),
            // Only supplied when a technician is assigned, so tracking is
            // never offered when there is no location to show.
            if (onTrackTapped != null) ...[
              AppButton(
                onPressed: onTrackTapped,
                text: 'تتبع الفني',
                backgroundColor: AppColors.carWashTeal,
                textColor: AppColors.white,
                borderRadius: 14.r,
                height: 52.h,
              ),
              SizedBox(height: 12.h),
            ],
            // Cancelling is only allowed while the request is still open;
            // the backend can_cancel flag is kept as an extra safety check.
            if (sos.status == 'open' && sos.canCancel == true)
              AppButton(
                onPressed: onCancelTapped,
                text: l10n.sosDetailsCancelRequest,
                backgroundColor: AppColors.reservationConfirmOrange,
                textColor: AppColors.white,
                borderRadius: 14.r,
                height: 52.h,
              ),
          ],
        ),
      ),
    );
  }
}
