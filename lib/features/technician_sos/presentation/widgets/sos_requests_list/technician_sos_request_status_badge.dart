import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TechnicianSosRequestStatusBadgeStyle {
  outlineOnWhite,
  softSuccess,
  softError,
}

/// Only the final states read as a status color — completed is green,
/// cancelled is red — everything else stays neutral so it's never mistaken
/// for "done" or "failed". Top-level so it's directly unit-testable without
/// pumping the card widget.
TechnicianSosRequestStatusBadgeStyle technicianSosRequestStatusBadgeStyleFor(
  String? status,
) {
  return switch (status) {
    'completed' => TechnicianSosRequestStatusBadgeStyle.softSuccess,
    'cancelled' => TechnicianSosRequestStatusBadgeStyle.softError,
    _ => TechnicianSosRequestStatusBadgeStyle.outlineOnWhite,
  };
}

class _SosRequestStatusBadgeLayout {
  _SosRequestStatusBadgeLayout._();

  static double get width => 108.w;
  static double get height => 36.h;
}

class SosTechnicianRequestStatusBadge extends StatelessWidget {
  const SosTechnicianRequestStatusBadge({
    super.key,
    required this.label,
    required this.style,
  });

  final String label;
  final TechnicianSosRequestStatusBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    final bool outline =
        style == TechnicianSosRequestStatusBadgeStyle.outlineOnWhite;
    final bool isError =
        style == TechnicianSosRequestStatusBadgeStyle.softError;
    return Container(
      width: _SosRequestStatusBadgeLayout.width,
      height: _SosRequestStatusBadgeLayout.height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: outline
            ? AppColors.white
            : isError
            ? AppColors.errorBannerSurface
            : AppColors.serviceTierSelectedBackground,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: outline
              ? AppColors.carWashTeal
              : isError
              ? AppColors.red
              : AppColors.green,
          width: 1,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
