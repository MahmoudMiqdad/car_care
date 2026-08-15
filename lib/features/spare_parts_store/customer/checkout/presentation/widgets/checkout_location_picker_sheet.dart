//مايا:مستقل تماما عن خريطة الفني ولكن نفس النمط فعليا

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CheckoutLocationPickerSheet extends StatefulWidget {
  const CheckoutLocationPickerSheet({super.key, this.initialLocation});

  final LatLng? initialLocation;

  static Future<LatLng?> show(BuildContext context, {LatLng? initialLocation}) {
    return showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          CheckoutLocationPickerSheet(initialLocation: initialLocation),
    );
  }

  @override
  State<CheckoutLocationPickerSheet> createState() =>
      _CheckoutLocationPickerSheetState();
}

class _CheckoutLocationPickerSheetState
    extends State<CheckoutLocationPickerSheet> {
  final MapController _mapController = MapController();

  // بصرى الشام كموقع افتراضي
  static const LatLng _defaultCenter = LatLng(32.5198, 36.4826);

  late LatLng _pickedLocation;
  bool _loadingGps = false;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation ?? _defaultCenter;
    _goToCurrentLocation();
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _loadingGps = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final current = LatLng(pos.latitude, pos.longitude);
        if (mounted) {
          setState(() => _pickedLocation = current);
          _mapController.move(current, 15);
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _loadingGps = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.accent, size: 22.sp),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    'حدد موقع التوصيل',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _loadingGps ? null : _goToCurrentLocation,
                  icon: _loadingGps
                      ? SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                  label: Text(
                    'موقعي',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'حرّك الخريطة لتحديد موقع التوصيل',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _pickedLocation,
                    initialZoom: 15,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        setState(() => _pickedLocation = position.center);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.car_care.app',
                    ),
                  ],
                ),
                // دبوس ثابت في مركز الخريطة
                IgnorePointer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.white,
                          size: 22.sp,
                        ),
                      ),
                      Container(
                        width: 2.w,
                        height: 14.h,
                        color: AppColors.accent,
                      ),
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                // عرض الإحداثيات الحالية
                Positioned(
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      '${_pickedLocation.latitude.toStringAsFixed(5)}, '
                      '${_pickedLocation.longitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: 16.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, _pickedLocation),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.check_circle_outline, size: 20.sp),
                  label: Text(
                    'تأكيد الموقع',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
