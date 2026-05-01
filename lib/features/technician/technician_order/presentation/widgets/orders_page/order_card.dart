// ignore_for_file: deprecated_member_use

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/request_priority_chip.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/available_requests_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.item, required this.onTap});

  final AvailableRequestDataEntity item;

  final VoidCallback onTap;

  static String _formatDate(DateTime d) => '${d.year}/${d.month}/${d.day}';

  @override
  Widget build(BuildContext context) {
    final radius = AppConstants.maintenanceRequestCardRadius.r;

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImageWidget(
                path: item.images.isNotEmpty ? item.images[0].url : '',
                width: 100.w,
                height: 130.w,
                borderRadius: 8.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppInfoRow(
                      label: 'وصف',
                      value: item.description,
                      labelFontSize: 16.sp,
                    ),
                    AppInfoRow(label: 'العميل', value: item.customer.name),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppInfoRow(
                            label: 'المركبة',
                            value: item.vehicle.brand,
                          ),
                        ),
                        // SizedBox(width: 5.w),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.vehicle.model,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    AppInfoRow(
                      label: 'التاريخ',
                      value: _formatDate(item.createdAt),
                    ),
                    SizedBox(height: 4.h),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RequestPriorityChip(
          label: item.priority.labelAr,
          style: PriorityChipStyle.forState(
            value: item.priority,
            selected: item.priority,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
        ),
        Icon(
          Icons.keyboard_double_arrow_left,
          size: 22.sp,
          color: AppColors.lightTextSecondary.withOpacity(0.6),
        ),
      ],
    );
  }
}
