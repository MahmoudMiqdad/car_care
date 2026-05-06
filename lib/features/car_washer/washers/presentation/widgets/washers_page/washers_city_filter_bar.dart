import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WashersCityFilterBar extends StatelessWidget {
  const WashersCityFilterBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          child: Row(
            children: [
          
              _LocationGlyph(size: 36.r),
              SizedBox(width: 10.w),

              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: context.l10n.washersByCity,
                    hintStyle: TextStyle(
                      color: AppColors.lightTextPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),

              
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, value, _) {
                  final hasText = value.text.trim().isNotEmpty;
                  if (!hasText) return SizedBox(width: 4.w);

                  return InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.r,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ],
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