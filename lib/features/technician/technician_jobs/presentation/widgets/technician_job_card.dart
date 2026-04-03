import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TechnicianJobCardStatus { waiting, rejected }

class TechnicianJobUiModel {
  const TechnicianJobUiModel({
    required this.status,
    required this.description,
    required this.customerName,
    required this.vehicle,
    required this.appointmentDate,
    required this.priceOffer,
  });

  final TechnicianJobCardStatus status;
  final String description;
  final String customerName;
  final String vehicle;
  final String appointmentDate;
  final String priceOffer;
}

class TechnicianJobCard extends StatelessWidget {
  const TechnicianJobCard({super.key, required this.job});

  final TechnicianJobUiModel job;

  @override
  Widget build(BuildContext context) {
    final bool isWaiting = job.status == TechnicianJobCardStatus.waiting;
        final Color statusBg = isWaiting ? const Color(0xFFD1F0F7) : const Color(0xFFFFE5E7);
    final Color statusColor = isWaiting ? const Color(0xFF007A92) : AppColors.error;
    final double localLabelSize = 17.sp;
    final double localValueSize = 16.sp;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Container(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppInfoRow(
                        label: 'وصف',
                        value: job.description,
                        labelFontSize: localLabelSize,
                        valueFontSize: localValueSize,
                        leading: _rowAsset(AppAssets.technicianJobNotesIcon),
                      ),
                      AppInfoRow(
                        label: 'العميل',
                        value: job.customerName,
                        labelFontSize: localLabelSize,
                        valueFontSize: localValueSize,
                        leading: _rowAsset(AppAssets.technicianJobProfileIcon),
                      ),
                      AppInfoRow(
                        label: 'المركبة',
                        value: job.vehicle,
                        labelFontSize: localLabelSize,
                        valueFontSize: localValueSize,
                        leading: Icon(Icons.directions_car_filled_rounded, size: 20.sp, color: AppColors.primary),
                      ),
                      AppInfoRow(
                        label: 'الموعد',
                        value: job.appointmentDate,
                        labelFontSize: localLabelSize,
                        valueFontSize: localValueSize,
                        leading: _rowAsset(AppAssets.calendarIcon),
                      ),
                      AppInfoRow(
                        label: 'عرض السعر',
                        value: job.priceOffer,
                        labelFontSize: localLabelSize,
                        valueFontSize: localValueSize,
                        leading: Icon(Icons.monetization_on_rounded, size: 20.sp, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                child: Container(
                  color: statusBg,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isWaiting)
                        Image.asset(
                          AppAssets.technicianJobTimeIcon,
                          width: 45.sp,
                          height: 45.sp,
                          color: statusColor,
                        )
                      else
                        Container(
                          width: 45.r,
                          height: 45.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor, width: 2.5),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: statusColor,
                            size: 32.sp,
                          ),
                        ),
                      SizedBox(height: 8.h),
                      Text(
                        isWaiting ? 'إنتظار' : 'مرفوض',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      errorBuilder: (_, __, ___) => Icon(Icons.info_outline, size: 20.sp, color: AppColors.primary),
    );
  }
}