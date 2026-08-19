// كرت يعرض موقع التوصيل المختار أو يدعو لاختياره
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
class CheckoutLocationCard extends StatelessWidget {
  const CheckoutLocationCard({
    super.key,
    required this.selectedLocation,
    required this.onPickLocation,
  });

  final LatLng? selectedLocation;
  final VoidCallback onPickLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 
    final isSelected = selectedLocation != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.04)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12), 
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.accent,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.deliveryLocationLabel, 
                      style: context.textTheme.labelLarge!.copyWith(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                      child: !isSelected
                          ? Text(
                              l10n.selectLocationFromMapHint, 
                              key: const ValueKey('hint'),
                              style: context.textTheme.labelSmall!.copyWith(
                                color: AppColors.textSecondary(context),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: isSelected
                    ? Container(
                        key: const ValueKey('badge'),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.12), 
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.green,
                              size: 12.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              l10n.locationSelectedBadge, 
                              style:context.textTheme.labelSmall!.copyWith(
                                color: AppColors.green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('no-badge')),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: isSelected ? 1 : 0,
              child: isSelected
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${selectedLocation!.latitude.toStringAsFixed(5)}, '
                          '${selectedLocation!.longitude.toStringAsFixed(5)}',
                          style:context.textTheme.labelSmall!.copyWith(
                            color: AppColors.textSecondary(context),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onPickLocation,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07), 
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 16.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      isSelected ? l10n.changeLocationButton : l10n.selectLocationFromMapHint, 
                      key: ValueKey(isSelected),
                      style: context.textTheme.labelSmall!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
