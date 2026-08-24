import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washer_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationHeaderInfo extends StatelessWidget {
  const ReservationHeaderInfo({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    final locationText = washer.fullAddress.isNotEmpty
        ? washer.fullAddress
        : washer.city;

    return Column(
      children: <Widget>[
        Center(child: WasherAvatar(logoUrl: washer.logoUrl, diameter: 100)),
        SizedBox(height: 8.h),
        Text(
          washer.shopName,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall!.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          locationText,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
