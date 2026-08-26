import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/cancel_reason_dialog.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuotationDetailsBody extends StatelessWidget {
  const QuotationDetailsBody({
    super.key,
    required this.quotation,
    this.onAccept,
    this.onReject,
    this.isLoading = false,
  });

  final QuotationEntity quotation;
  final VoidCallback? onAccept;
  final void Function(String reason)? onReject;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final isPending = quotation.status == 'pending';

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
            SosDetailsStatusBanner(
              label: maintenanceRequestStatusLabel(
                context,
                quotation.status,
                fallback: quotation.statusText,
              ),
            ),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: l10n.technicianInfoCardTitle,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          quotation.technician.name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.iconPhoneCall,
                          label: l10n.profileWasherFieldPhone,
                          value: quotation.technician.phone,
                        ),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.technicianJobVehicleIcon,
                          label: l10n.specializationLabel,
                          value: quotation
                              .technician
                              .technicianProfile
                              .specialization,
                        ),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.calendarIcon,
                          label: l10n.experienceYearsLabel,
                          value: l10n.durationInYears(
                            quotation
                                .technician
                                .technicianProfile
                                .experienceYears,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: AppColors.cardBackground(context),
                    backgroundImage: const AssetImage(
                      AppAssets.technicianJobVehicleIcon,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: l10n.quotationDetailsTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.fuelOrderMoneyIcon,
                    label: l10n.price,
                    value: quotation.priceFormatted,
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.calendarIcon,
                    label: l10n.repairDurationLabel,
                    value: l10n.durationInDays(quotation.estimatedDays),
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.NotesIcon,
                    label: l10n.partsIncludedLabel,
                    value: quotation.partsIncluded ? l10n.yes : l10n.no,
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.calendarIcon,
                    label: l10n.quotationDateLabel,
                    value: quotation.createdAgo,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: l10n.technicianNotesCardTitle,
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
                      quotation.notes,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),

            if (isPending) ...[
              AppButton(
                onPressed: isLoading ? null : (onAccept ?? () {}),
                isLoading: isLoading,
                text: l10n.acceptQuotationButton,
                backgroundColor: AppColors.carWashTeal,
                textColor: AppColors.white,
                borderRadius: 14.r,
                height: 52.h,
              ),
              SizedBox(height: 12.h),
              AppButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final reason = await showCancelReasonDialog(
                          context,
                          title: l10n.rejectQuotationReasonTitle,
                        );
                        if (reason != null && reason.isNotEmpty) {
                          onReject?.call(reason);
                        }
                      },
                isLoading: isLoading,
                text: l10n.rejectQuotationButton,
                backgroundColor: AppColors.reservationConfirmOrange,
                textColor: AppColors.white,
                borderRadius: 14.r,
                height: 52.h,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
