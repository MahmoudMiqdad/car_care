import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationVehiclePickerCard extends StatelessWidget {
  const ReservationVehiclePickerCard({
    super.key,
    required this.vehicleState,
    required this.selectedVehicle,
    required this.onTap,
  });

  final VehicleState vehicleState;
  final VehicleEntity? selectedVehicle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content;
    final string = context.l10n;
    if (vehicleState is VehicleLoading || vehicleState is VehicleInitial) {
      content = Row(
        children: [
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.carWashTeal,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            string.loadingYourVehicles,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      );
    } else if (vehicleState is VehicleEmpty) {
      content = Row(
        children: [
          Icon(Icons.info_outline, size: 18.sp, color: AppColors.accent),
          SizedBox(width: 8.w),
          Text(
            string.noVehiclesAdded,
            style: TextStyle(fontSize: 14.sp, color: AppColors.accent),
          ),
        ],
      );
    } else if (selectedVehicle != null) {
      content = Row(
        children: [
          Icon(
            Icons.directions_car_rounded,
            size: 20.sp,
            color: AppColors.carWashTeal,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '${selectedVehicle!.brand} ${selectedVehicle!.model} ${selectedVehicle!.year}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Icon(
            Icons.swap_horiz_rounded,
            size: 18.sp,
            color: AppColors.carWashTeal,
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 20.sp,
            color: AppColors.carWashTeal,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              string.selectYourVehicle,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            size: 20.sp,
            color: AppColors.textSecondary(context),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selectedVehicle != null
                ? AppColors.carWashTeal
                : context.colorScheme.outlineVariant,
            width: 1.2,
          ),
        ),
        child: content,
      ),
    );
  }
}
