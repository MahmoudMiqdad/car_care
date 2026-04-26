import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WashersCityFilterBar extends StatelessWidget {
  const WashersCityFilterBar({super.key, this.onFilterTap});

  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: Material(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onFilterTap,
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.washersByCity,
                  style: TextStyle(
                    color: AppColors.lightTextPrimary,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _LocationGlyph(size: 34.r),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationGlyph extends StatelessWidget {
  const _LocationGlyph({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Center(
        child: Icon(
          Icons.location_on,
          size: 20.r,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
