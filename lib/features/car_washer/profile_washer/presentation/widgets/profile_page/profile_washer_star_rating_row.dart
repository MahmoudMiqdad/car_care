import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherStarRatingRow extends StatelessWidget {
  const ProfileWasherStarRatingRow({
    super.key,
    this.filledCount = 3,
    this.iconSize,
  });

  final int filledCount;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 28.sp;
    final color = AppColors.carWashTeal;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int i) {
        final bool filled = i < filledCount;
        return Padding(
          padding: EdgeInsetsDirectional.only(end: i == 4 ? 0 : 2.w),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: color,
          ),
        );
      }),
    );
  }
}
