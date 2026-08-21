import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Compact read-only title/value row (icon + label + value) used inside a
/// [TechnicianProfileSection] card on the Profile View screen. Deliberately
/// has no card/border of its own — the section around it is the only card,
/// so rows don't nest card-in-card.
class TechnicianInfoRow extends StatelessWidget {
  const TechnicianInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary.withValues(alpha: 0.7)),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: AppColors.gray),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
