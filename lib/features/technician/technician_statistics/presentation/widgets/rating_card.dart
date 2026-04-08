import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({
    super.key,
    required this.averageRating,
    required this.totalRatings,
  });

  final String averageRating;
  final int totalRatings;

  double get _rating => double.tryParse(averageRating) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    final rating = _rating.clamp(0.0, 5.0);

    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.star_outline_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'التقييم',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            Center(child: _Stars(rating: rating)),
          ],
        ),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        if (i < full) {
          return Icon(
            Icons.star_rounded,
            size: 26.sp,
            color: AppColors.primary,
          );
        }
        if (i == full && half) {
          return Icon(
            Icons.star_half_rounded,
            size: 26.sp,
            color: AppColors.primary,
          );
        }
        return Icon(
          Icons.star_border_rounded,
          size: 26.sp,
          color: AppColors.primary,
        );
      }),
    );
  }
}
