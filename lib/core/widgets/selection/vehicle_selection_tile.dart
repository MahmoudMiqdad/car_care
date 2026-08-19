import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single compact vehicle row for use inside a [SharedSelectionBottomSheet].
///
/// Uses only the canonical `VehicleEntity`
/// (`lib/features/vehicle/domain/entities/vehicle_entity.dart`) — never the
/// maintenance feature's separate, display-only vehicle entity.
///
/// Every field beyond the vehicle name is optional so each caller can keep
/// its own existing information density (e.g. the car-wash reservation
/// sheet shows no image and no plate number, while maintenance/SOS/fuel
/// show both).
class VehicleSelectionTile extends StatelessWidget {
  const VehicleSelectionTile({
    super.key,
    required this.vehicle,
    required this.isSelected,
    this.showImage = false,
    this.showYear = true,
    this.showPlateNumber = false,
    this.selectedColor = AppColors.primary,
  });

  final VehicleEntity vehicle;
  final bool isSelected;
  final bool showImage;
  final bool showYear;
  final bool showPlateNumber;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final nameLine = showYear
        ? '${vehicle.brand} ${vehicle.model} ${vehicle.year}'
        : '${vehicle.brand} ${vehicle.model}';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? selectedColor.withValues(alpha: 0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? selectedColor : Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          if (showImage)
            _VehicleAvatar(vehicle: vehicle, color: selectedColor)
          else
            Icon(
              Icons.directions_car_rounded,
              color: selectedColor,
              size: 22.sp,
            ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nameLine,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                if (showPlateNumber)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      vehicle.plateNumber,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: selectedColor, size: 20.sp),
        ],
      ),
    );
  }
}

class _VehicleAvatar extends StatelessWidget {
  const _VehicleAvatar({required this.vehicle, required this.color});

  final VehicleEntity vehicle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final image = vehicleImageRawValue(vehicle.image, vehicle.imagePath);

    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: image != null ? NetworkImage(image) : null,
      child: image == null
          ? Icon(Icons.directions_car, size: 18.sp, color: color)
          : null,
    );
  }
}
