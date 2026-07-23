// ignore_for_file: deprecated_member_use

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/location_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class LocationUpdateCard extends StatefulWidget {
  const LocationUpdateCard({
    super.key,
    this.localOnly = false,
    this.onLocationPicked,
  });

  /// When true (onboarding), the picker only returns the location locally —
  /// no protected endpoint is called. See [LocationPickerSheet.localOnly].
  final bool localOnly;

  /// Reports the picked location to the parent form.
  final ValueChanged<LatLng>? onLocationPicked;

  @override
  State<LocationUpdateCard> createState() => _LocationUpdateCardState();
}

class _LocationUpdateCardState extends State<LocationUpdateCard> {
  LatLng? _savedLocation;

  Future<void> _openPicker() async {
    final picked =
        await LocationPickerSheet.show(context, localOnly: widget.localOnly);
    if (picked != null) {
      setState(() => _savedLocation = picked);
      widget.onLocationPicked?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechnicianLocationCubit, TechnicianLocationState>(
      builder: (context, state) {
        final isSuccess =
            state is UpdateLocationSuccess || _savedLocation != null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSuccess ? Colors.green.shade300 : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
                      color: AppColors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.orange,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'موقع الورشة',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  
                  if (isSuccess)
                    Icon(Icons.check_circle,
                        color: Colors.green.shade600, size: 18.r),
                ],
              ),
              SizedBox(height: 8.h),

              
              if (_savedLocation != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.green.shade600, size: 14.r),
                      SizedBox(width: 6.w),
                      Text(
                        '${_savedLocation!.latitude.toStringAsFixed(4)}, '
                        '${_savedLocation!.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.green.shade700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  'حدد موقع ورشتك حتى يظهر للعملاء القريبين منك',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

              SizedBox(height: 12.h),

              // ─── زر فتح الخريطة ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
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
                        ? 'تغيير الموقع'
                        : 'تحديد الموقع على الخريطة',
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
