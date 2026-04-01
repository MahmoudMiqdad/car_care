import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_priority_chip.dart';
import 'package:car_care/features/orders/presentation/models/order_list_item.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.item, required this.onTap});

  final OrderListItem item;
  final VoidCallback onTap;
  static String _formatDate(DateTime d) => '${d.year}/${d.month}/${d.day}';
  @override
  Widget build(BuildContext context) {
    final radius = AppConstants.maintenanceRequestCardRadius.r;
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
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
                path: item.imageAssetPath,
                width: 100.w,
                height: 100.w,
                borderRadius: 8.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppInfoRow(label: 'وصف', value: item.description, labelFontSize: 16.sp),
                    AppInfoRow(label: 'العميل', value: item.customerName),
                    AppInfoRow(label: 'المركبة', value: item.vehicleInfo),
                    AppInfoRow(label: 'التاريخ', value: _formatDate(item.date)),
                    SizedBox(height: 4.h),
                    buildCardFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardFooter() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RequestPriorityChip(
          label: item.priority.labelAr,
          style: PriorityChipStyle.forState(value: item.priority, selected: item.priority),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
        ),
        Icon(
          Icons.keyboard_double_arrow_left,
          size: 22.sp,
          // ignore: deprecated_member_use
          color: AppColors.lightTextSecondary.withOpacity(0.6),
        ),
      ],
    );
  }
}