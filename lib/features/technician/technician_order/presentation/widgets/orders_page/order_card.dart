// ignore_for_file: deprecated_member_use

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/request_priority_chip.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/available_requests_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.item, required this.onTap});

  final AvailableRequestDataEntity item;
  final VoidCallback onTap;

  static String _formatDate(DateTime d) => '${d.year}/${d.month}/${d.day}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = AppConstants.maintenanceRequestCardRadius.r;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.08),
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
                      label: l10n.descriptionLabel,
                      value: item.description,
                      labelFontSize: 16.sp,
                    ),
                    AppInfoRow(
                      label: l10n.clientLabel,
                      value: item.customer.name,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppInfoRow(
                            label: l10n.vehicleLabel,
                            value: item.vehicle.brand,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.vehicle.model,
                            textAlign: isRtl ? TextAlign.right : TextAlign.left,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppInfoRow(
                      label: l10n.dateLabel,
                      value: _formatDate(item.createdAt),
                    ),
                    SizedBox(height: 4.h),
                    _buildFooter(context, isRtl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isRtl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RequestPriorityChip(
          label: item.priority.localizedLabel(context),
          style: PriorityChipStyle.forState(
            context: context,
            value: item.priority,
            selected: item.priority,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
        ),
        Icon(
          isRtl
              ? Icons.keyboard_double_arrow_left
              : Icons.keyboard_double_arrow_right,
          size: 22.sp,
          color: AppColors.textSecondary(context).withValues(alpha: 0.6),
        ),
      ],
    );
  }
}
