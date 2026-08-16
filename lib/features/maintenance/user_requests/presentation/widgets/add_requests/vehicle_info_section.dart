import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/vehicle_header.dart';
import 'package:car_care/core/widgets/vehicle_info_components.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleInfoSection extends StatelessWidget {
  const VehicleInfoSection({
    super.key,
    required this.cardRadius,
    this.vehicle,
    this.onPickVehicle,
    this.isLoading = false,
  });

  final double cardRadius;

  /// Selected vehicle; when null the picker prompt is shown instead.
  final VehicleEntity? vehicle;
  final VoidCallback? onPickVehicle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final v = vehicle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VehicleHeader(
          imagePath: v?.image ?? '',
          isNetworkImage: v?.image != null && v!.image!.isNotEmpty,
          title: v == null
              ? 'لم يتم اختيار مركبة'
              : '${v.brand} ${v.model} ${v.year}',
          bottomChild: v == null
              ? null
              : Row(
                  children: [
                    Expanded(
                      child: VehicleInfoPill(
                        borderRadius: cardRadius,
                        icon: Icons.speed,
                        text: '${v.currentKm} كم',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: VehicleInfoPill(
                        borderRadius: cardRadius,
                        imagePath: 'assets/images/number.png',
                        text: v.plateNumber,
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(height: 14.h),
        OutlinedButton.icon(
          onPressed: isLoading ? null : onPickVehicle,
          icon: Icon(
            v == null ? Icons.directions_car_outlined : Icons.swap_horiz,
            size: 18.sp,
          ),
          label: Text(v == null ? 'اختر المركبة' : 'تغيير المركبة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
          ),
        ),
      ],
    );
  }
}
