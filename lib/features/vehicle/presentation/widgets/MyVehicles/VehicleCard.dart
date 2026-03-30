// ignore_for_file: file_names

import 'package:car_care/core/constants/app_text_styles.dart';
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.item});

  final VehicleEntity item;

  @override
  Widget build(BuildContext context) {
    return AppBoxContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              VehicleCircleImage(imageUrl: item.image),
              SizedBox(width: 16.w),
              Expanded(
                child: VehicleInfoColumn(item: item),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: 'التفاصيل',
            backgroundColor: AppColors.orange,
            borderRadius: 16.r,
            height: 48.h,
            fontSize: 18.sp,
            onPressed: () {
              context.push(Routes.vehicle_details, extra: item.id);
            },
          ),
        ],
      ),
    );
  }
}

class VehicleInfoColumn extends StatelessWidget {
  final VehicleEntity item;
  const VehicleInfoColumn({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${item.brand} ${item.model}',
          style: AppTextStyles.font20BlackBold.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        buildInfoRow('السنة', item.year.toString()),
        buildInfoRow('رقم اللوحة', item.plateNumber),
        buildInfoRow('عداد', item.currentKm.toString()),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        '$label : $value',
        style: AppTextStyles.font18BlackSemiBold.copyWith(fontSize: 16.sp),
      ),
    );
  }
}

class VehicleCircleImage extends StatelessWidget {
  final String? imageUrl;
  const VehicleCircleImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    return Container(
      width: 90.w,
      height: 90.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightBorder,
      ),
      child: ClipOval(
        child: (url != null && url.isNotEmpty)
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() => Icon(Icons.directions_car, size: 40.sp, color: AppColors.orange);
}