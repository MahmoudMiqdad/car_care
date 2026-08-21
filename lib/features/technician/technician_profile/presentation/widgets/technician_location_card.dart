// ignore_for_file: deprecated_member_use

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/location_picker_sheet.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
class LocationUpdateCard extends StatefulWidget {
  const LocationUpdateCard({
    super.key,
    this.localOnly = false,
    this.onLocationPicked,
    this.initialDescription,
    this.initialButtonLabel,
  });

  final bool localOnly;
  final ValueChanged<LatLng>? onLocationPicked;
  final String? initialDescription;
  final String? initialButtonLabel;

  @override
  State<LocationUpdateCard> createState() => _LocationUpdateCardState();
}

class _LocationUpdateCardState extends State<LocationUpdateCard> {
  LatLng? _savedLocation;

  Future<void> _openPicker() async {
    final picked = await LocationPickerSheet.show(
      context,
      localOnly: widget.localOnly,
    );
    if (picked != null) {
      setState(() => _savedLocation = picked);
      widget.onLocationPicked?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<TechnicianLocationCubit, TechnicianLocationState>(
      builder: (context, state) {
        final isSuccess =
            state is UpdateLocationSuccess || _savedLocation != null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSuccess ? AppColors.green : AppColors.border(context),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.accent,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    l10n.workshopLocationTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const Spacer(),
                  if (isSuccess)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.green,
                      size: 18.r,
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              if (_savedLocation != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.green,
                        size: 14.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${_savedLocation!.latitude.toStringAsFixed(4)}, '
                        '${_savedLocation!.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.green,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  widget.initialDescription ?? l10n.workshopLocationDescriptionHint,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  icon: Icon(
                    _savedLocation != null
                        ? Icons.edit_location_alt
                        : Icons.add_location_alt,
                    size: 18.r,
                  ),
                  label: Text(
                    _savedLocation != null
                        ? l10n.changeLocationButton
                        : (widget.initialButtonLabel ?? l10n.selectLocationFromMapHint),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
