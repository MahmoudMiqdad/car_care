// ignore_for_file: file_names
import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.item});

  final VehicleEntity item;

  @override
  Widget build(BuildContext context) {
          final strings = context.l10n;
    return AppBoxContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            text:strings.details,
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
        AppText.sectionTitle(
          '${item.brand} ${item.model}',
          color: AppColors.black,
        ),
        SizedBox(height: 8.h),
        AppInfoRow(
          label: 'السنة',
          value: item.year.toString(),
          labelFontSize: 16.sp,
          valueFontSize: 16.sp,
        ),
        SizedBox(height: 4.h),
        AppInfoRow(
          label: 'رقم اللوحة',
          value: item.plateNumber,
          labelFontSize: 16.sp,
          valueFontSize: 16.sp,
        ),
        SizedBox(height: 4.h),
        AppInfoRow(
          label: 'عداد',
          value: '${item.currentKm} كم',
          labelFontSize: 16.sp,
          valueFontSize: 16.sp,
        ),
      ],
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