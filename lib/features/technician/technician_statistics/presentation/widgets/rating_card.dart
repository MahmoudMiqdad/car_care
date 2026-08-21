import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/statistics/stats_section_card.dart';
import 'package:car_care/l10n.dart';
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
    final string = context.l10n;
    final rating = _rating.clamp(0.0, 5.0);

    return StatsSectionCard(
      title: '${string.rating} ($totalRatings)',
      icon: Icons.star_outline_rounded,
      child: Center(child: _Stars(rating: rating)),
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
          return Icon(Icons.star_rounded, size: 26.sp, color: AppColors.accent);
        }
        if (i == full && half) {
          return Icon(
            Icons.star_half_rounded,
            size: 26.sp,
            color: AppColors.accent,
          );
        }
        return Icon(
          Icons.star_border_rounded,
          size: 26.sp,
          color: AppColors.accent,
        );
      }),
    );
  }
}
