// ignore_for_file: deprecated_member_use


import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({super.key, this.localOnly = false});

  /// When true (onboarding), confirming only returns the picked location —
  /// no call to the protected /technician/location endpoint. The location
  /// is sent later as part of the profile save request.
  final bool localOnly;

  static Future<LatLng?> show(BuildContext context, {bool localOnly = false}) {
    return showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TechnicianLocationCubit>(),
        child: LocationPickerSheet(localOnly: localOnly),
      ),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final MapController _mapController = MapController();

  LatLng _pickedLocation = const LatLng(33.3152, 44.3661);
  bool _loadingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _loadingCurrentLocation = true);
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
        setState(() => _pickedLocation = current);
        _mapController.move(current, 15);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingCurrentLocation = false);
  }

  Future<void> _confirmLocation() async {
    if (widget.localOnly) {
      // Onboarding: keep the location in local form state only.
      Navigator.pop(context, _pickedLocation);
      return;
    }
    context.read<TechnicianLocationCubit>().technicianLocation(
      lat: _pickedLocation.latitude,
      lng: _pickedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<TechnicianLocationCubit, TechnicianLocationState>(
      listener: (context, state) {
        if (state is UpdateLocationSuccess) {
          Navigator.pop(context, _pickedLocation);
          AppSnackBar.success(context, l10n.workshopLocationSet);
        }
        if (state is UpdateLocationError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // ─── Handle ──────────────────────────────────────────────
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),

            // ─── العنوان ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.orange, size: 22.r),
                  SizedBox(width: 8.w),
                  Text(
                    l10n.selectWorkshopLocation,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // زر موقعي الحالي
                  TextButton.icon(
                    onPressed: _loadingCurrentLocation
                        ? null
                        : _goToCurrentLocation,
                    icon: _loadingCurrentLocation
                        ? SizedBox(
                            width: 14.r,
                            height: 14.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.orange,
                            ),
                          )
                        : Icon(
                            Icons.my_location,
                            size: 16.r,
                            color: AppColors.orange,
                          ),
                    label: Text(
                      l10n.myLocation,
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                l10n.moveMapToSelectLocation,
                style: TextStyle(fontSize: 12.sp, color: AppColors.white),
              ),
            ),
            SizedBox(height: 12.h),

            // ─── الخريطة ──────────────────────────────────────────────
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _pickedLocation,
                      initialZoom: 15,
                      // لما يتحرك الخريطة يتحدث الموقع
                      onPositionChanged: (position, hasGesture) {
                        // ignore: unnecessary_null_comparison
                        if (hasGesture && position.center != null) {
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

                  // ─── البن الثابت في المنتصف ──────────────────────
                  IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.orange.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.build_circle,
                            color: AppColors.white,
                            size: 24.r,
                          ),
                        ),
                        // الخط تحت البن
                        Container(
                          width: 2.w,
                          height: 16.h,
                          color: AppColors.orange,
                        ),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── إحداثيات الموقع المختار ─────────────────────
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
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        '${_pickedLocation.latitude.toStringAsFixed(5)}, '
                        '${_pickedLocation.longitude.toStringAsFixed(5)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── زر التأكيد (فوق الشريط الآمن دائمًا) ────────────────
            BlocBuilder<TechnicianLocationCubit, TechnicianLocationState>(
              builder: (context, state) {
                final isLoading = state is UpdateLocationLoading;
                return SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          disabledBackgroundColor: AppColors.white,
                        ),
                        icon: isLoading
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Icon(Icons.check_circle_outline, size: 20.r),
                        label: Text(
                          isLoading ? l10n.savingInProgress : l10n.confirmLocationAction,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}