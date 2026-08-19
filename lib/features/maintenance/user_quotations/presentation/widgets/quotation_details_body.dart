import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/cancel_reason_dialog.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_info_row.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_section_card.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_status_banner.dart';
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
            SosDetailsStatusBanner(label: quotation.statusText),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: 'معلومات الفني',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
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
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.iconPhoneCall,
                          label: 'الهاتف',
                          value: quotation.technician.phone,
                        ),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.technicianJobVehicleIcon,
                          label: 'التخصص',
                          value: quotation.technician.technicianProfile.specialization,
                        ),
                        SosDetailsInfoRow(
                          iconAsset: AppAssets.calendarIcon,
                          label: 'سنوات الخبرة',
                          value: '${quotation.technician.technicianProfile.experienceYears} سنوات',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: AppColors.lightSurface,
                    backgroundImage: const AssetImage(AppAssets.technicianJobVehicleIcon),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: 'تفاصيل العرض',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.fuelOrderMoneyIcon,
                    label: 'السعر',
                    value: quotation.priceFormatted,
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.calendarIcon,
                    label: 'مدة الإصلاح',
                    value: '${quotation.estimatedDays} أيام',
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.NotesIcon,
                    label: 'يشمل قطع الغيار',
                    value: quotation.partsIncluded ? 'نعم' : 'لا',
                  ),
                  SosDetailsInfoRow(
                    iconAsset: AppAssets.calendarIcon,
                    label: 'تاريخ العرض',
                    value: quotation.createdAgo,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            SosDetailsSectionCard(
              title: 'ملاحظات الفني',
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
                        color: AppColors.black,
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
                text: 'قبول العرض',
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
                          title: 'سبب رفض العرض',
                        );
                        if (reason != null && reason.isNotEmpty) {
                          onReject?.call(reason);
                        }
                      },
                isLoading: isLoading,
                text: 'رفض العرض',
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