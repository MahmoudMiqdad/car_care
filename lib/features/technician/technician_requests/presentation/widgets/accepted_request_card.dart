import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/technician/technician_requests/presentation/widgets/accepted_request_status_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AcceptedRequestWorkPhase { finished, inProgress, waiting }

class AcceptedRequestUiModel {
  const AcceptedRequestUiModel({
    required this.activePhase,
    required this.description,
    required this.clientName,
    required this.vehicle,
    required this.appointmentDate,
    required this.appointmentNotes,
  });

  final AcceptedRequestWorkPhase activePhase;
  final String description;
  final String clientName;
  final String vehicle;
  final String appointmentDate;
  final String appointmentNotes;
}

class AcceptedRequestCard extends StatelessWidget {
  const AcceptedRequestCard({
    super.key,
    required this.request,
    this.onStartWork,
    this.onEndWork,
    this.onViewDetails,
  });

  final AcceptedRequestUiModel request;
  final VoidCallback? onStartWork;
  final VoidCallback? onEndWork;
  final VoidCallback? onViewDetails;

  static final double _cardR = AppConstants.maintenanceRequestCardRadius.r;

  @override
  Widget build(BuildContext context) {
    final double labelFs = 17.sp;
    final double valueFs = 16.sp;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_cardR),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardR),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppInfoRow(
                        label: 'وصف',
                        value: request.description,
                        labelFontSize: labelFs,
                        valueFontSize: valueFs,
                        leading: Icon(
                        Icons.note_alt_outlined,
                       size: 22.sp, 
                       color: AppColors.primary,
  ),),
                          AppInfoRow(
                            label: 'العميل',
                            value: request.clientName,
                            labelFontSize: labelFs,
                            valueFontSize: valueFs,
                            leading: _rowAsset(AppAssets.technicianJobProfileIcon),
                          ),
                          AppInfoRow(
                         label: 'المركبة',
                         value: request.vehicle,
                         labelFontSize: labelFs,
                         valueFontSize: valueFs,
                         leading: Icon(
                         Icons.directions_car_outlined,
                         size: 20.sp,
                        color: AppColors.primary,
                          ),),
                          AppInfoRow(
                            label: 'الموعد',
                            value: request.appointmentDate,
                            labelFontSize: labelFs,
                            valueFontSize: valueFs,
                            leading: _rowAsset(AppAssets.calendarIcon),
                          ),
                          AppInfoRow(
                            label: 'ملاحظات الموعد',
                            value: request.appointmentNotes,
                            labelFontSize: labelFs,
                            valueFontSize: valueFs,
                            leading: _rowAsset(AppAssets.technicianJobNotesIcon),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1,height: 100, color: AppColors.primary),
                  AcceptedRequestStatusColumn(activePhase: request.activePhase),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 2.h, 12.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'بدء العمل',
                          isOutline: true,
                          backgroundColor: AppColors.primary,
                          borderRadius: _cardR,
                          outlineSurfaceColor: AppColors.white,
                          textColor: AppColors.primary,
                          height: 44.h,
                          onPressed: onStartWork ?? () {},
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AppButton(
                          text: 'إنهاء العمل',
                          isOutline: true,
                          backgroundColor: AppColors.primary,
                          borderRadius: _cardR,
                          outlineSurfaceColor: AppColors.white,
                          textColor: AppColors.primary,
                          height: 44.h,
                          onPressed: onEndWork ?? () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  AppButton(
                    text: 'عرض التفاصيل',
                    backgroundColor: AppColors.orange,
                    borderRadius: _cardR,
                    height: 50.h,
                    onPressed: onViewDetails ?? () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowAsset(String path) {
    return Image.asset(
      path,
      width: 20.sp,
      height: 20.sp,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
    );
  }
}
