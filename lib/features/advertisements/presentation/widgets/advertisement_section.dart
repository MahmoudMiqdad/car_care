// مسؤول عن تحميل إعلانات موضع محدد وعرضها أو إخفاء القسم بالكامل بأمان.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_cubit.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_state.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({
    super.key,
    required this.placement,
    required this.height,
    this.borderRadius = 16,
    this.bottomSpacing = 0,
  });

  final AdvertisementPlacement placement;
  final double height;
  final double borderRadius;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdvertisementCubit>()..loadAdvertisements(placement),
      child: BlocBuilder<AdvertisementCubit, AdvertisementState>(
        builder: (context, state) {
          Widget? body;

          if (state is AdvertisementLoading || state is AdvertisementInitial) {
            body = _LoadingPlaceholder(
              height: height,
              borderRadius: borderRadius,
            );
          } else if (state is AdvertisementLoaded && state.items.isNotEmpty) {
            body = AdvertisementCarousel(
              advertisements: state.items,
              height: height,
              borderRadius: borderRadius,
            );
          }

          if (body == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.only(bottom: bottomSpacing.h),
            child: body,
          );
        },
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({required this.height, required this.borderRadius});

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: Container(
        height: height.h,
        width: double.infinity,
        color: AppColors.black,
      ),
    );
  }
}
