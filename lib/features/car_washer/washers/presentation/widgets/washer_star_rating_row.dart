import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherStarRatingRow extends StatelessWidget {
  const WasherStarRatingRow({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int i) {
        late final IconData icon;
        if (i < full) {
          icon = Icons.star_rounded;
        } else if (i == full && half) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(end: i == 4 ? 0 : 1.w),
          child: Icon(
            icon,
            size: 31.sp,
            color: i < full || (i == full && half)
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }
}
