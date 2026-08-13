import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_star_rating_row.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The single shared "التقييمات" section — used both inside the washer's
/// own profile page and inside the customer-facing washer details page.
/// Owns its own [CarWasherRatingsCubit] instance (each screen gets one,
/// per the existing `registerFactory` in the service locator) and fetches
/// once per [carWasherId]; it never navigates to a standalone page.
class CarWasherRatingsSection extends StatefulWidget {
  const CarWasherRatingsSection({super.key, required this.carWasherId});

  final int carWasherId;

  @override
  State<CarWasherRatingsSection> createState() =>
      _CarWasherRatingsSectionState();
}

class _CarWasherRatingsSectionState extends State<CarWasherRatingsSection> {
  late final CarWasherRatingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CarWasherRatingsCubit>()..fetchRatings(widget.carWasherId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'التقييمات',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<CarWasherRatingsCubit, CarWasherRatingsState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CarWasherRatingsState state) {
    if (state is CarWasherRatingsInitial || state is CarWasherRatingsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state is CarWasherRatingsError) {
      return Column(
        children: [
          Text(
            state.message,
            style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          TextButton.icon(
            onPressed: () => _cubit.fetchRatings(widget.carWasherId),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      );
    }

    final loaded = state as CarWasherRatingsLoaded;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileWasherStarRatingRow(
              filledCount: loaded.averageRating.round(),
              iconSize: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '${loaded.averageRating.toStringAsFixed(1)} (${loaded.totalRatings} تقييمًا)',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (loaded.ratings.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'لا توجد تقييمات بعد',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lightTextSecondary,
              ),
            ),
          )
        else ...[
          for (final rating in loaded.ratings) _ReviewTile(rating: rating),
          if (loaded.hasMore) ...[
            SizedBox(height: 4.h),
            Center(
              child: loaded.isLoadingMore
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : TextButton(
                      onPressed: () => _cubit.loadMore(widget.carWasherId),
                      child: const Text('عرض المزيد'),
                    ),
            ),
          ],
        ],
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.rating});

  final CarWasherRatingEntity rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  rating.userName.isNotEmpty ? rating.userName : 'مستخدم',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              ProfileWasherStarRatingRow(
                filledCount: rating.rating.clamp(0, 5),
                iconSize: 14.sp,
              ),
            ],
          ),
          if (rating.review.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              rating.review,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
          if (rating.createdAgo.isNotEmpty || rating.createdAt.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              rating.createdAgo.isNotEmpty
                  ? rating.createdAgo
                  : rating.createdAt,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
          const Divider(height: 16),
        ],
      ),
    );
  }
}
