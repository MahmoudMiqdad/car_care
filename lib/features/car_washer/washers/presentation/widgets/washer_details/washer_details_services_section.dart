import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_service_tier.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_tier_l10n.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetailsServicesSection extends StatelessWidget {
  const WasherDetailsServicesSection({super.key, required this.washer});

  final WasherEntity washer;

  static const List<WasherServiceTier> _rowOrder = <WasherServiceTier>[
    WasherServiceTier.premium,
    WasherServiceTier.vip,
    WasherServiceTier.basic,
  ];

  String _tierKey(WasherServiceTier tier) {
    switch (tier) {
      case WasherServiceTier.basic:
        return 'basic';
      case WasherServiceTier.vip:
        return 'vip';
      case WasherServiceTier.premium:
        return 'premium';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final visibleTiers = _rowOrder
        .where((t) => washer.servicePrices.containsKey(_tierKey(t)))
        .toList();

    if (visibleTiers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppText.sectionTitle(
          l10n.washerSectionServicesAndPrices,
          color: AppColors.lightTextPrimary,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var i = 0; i < visibleTiers.length; i++) ...<Widget>[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: ServicePackageCard(
                  tier: visibleTiers[i],
                  priceUsd: washer.servicePrices[_tierKey(visibleTiers[i])]!,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ServicePackageCard extends StatelessWidget {
  const ServicePackageCard({
    super.key,
    required this.tier,
    required this.priceUsd,
  });

  final WasherServiceTier tier;
  final int priceUsd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = washerTierLabel(context, tier);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(6.w, 8.h, 6.w, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
              ),
            ),
          //   SizedBox(height: 6.h),
          //   Divider(
          //     color: AppColors.primary.withValues(alpha: 0.55),
          //     height: 1,
          //     thickness: 1.4,
          //   ),
          //   SizedBox(height: 8.h),
          //  // CheckLine(text: l10n.washerServiceExterior),
          //   SizedBox(height: 4.h),
          //   CheckLine(text: l10n.washerServiceInterior),
          //   SizedBox(height: 4.h),
          //   CheckLine(text: l10n.washerServiceEngine),
          //   SizedBox(height: 8.h),
            Divider(
              color: AppColors.primary.withValues(alpha: 0.45),
              height: 2,
              thickness: 1.3,
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.washerPackagePrice(priceUsd),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckLine extends StatelessWidget {
  const CheckLine({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: 16.r,
          height: 16.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: AppColors.primary, width: 1),
            color: AppColors.white,
          ),
          child: Image.asset(
            AppAssets.iconCheckMark16,
            width: 10.r,
            height: 10.r,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Icon(
              Icons.check,
              size: 10.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.lightTextPrimary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}