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

  @override
  Widget build(BuildContext context) {
    final double rating = double.tryParse(averageRating) ?? 0.0;

    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقييم:',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                _Stars(rating: rating),
                SizedBox(width: 10.w),
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '($totalRatings)',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ],
            ),
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
    final int full = rating.floor().clamp(0, 5);
    final bool half = (rating - full) >= 0.5 && full < 5;
    final int empty = 5 - full - (half ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < full; i++)
          const Icon(Icons.star, color: AppColors.primary, size: 22),
        if (half)
          const Icon(Icons.star_half, color: AppColors.primary, size: 22),
        for (int i = 0; i < empty; i++)
          Icon(
            Icons.star_border,
            color: AppColors.primary.withOpacity(.6),
            size: 22,
          ),
      ],
    );
  }
}
