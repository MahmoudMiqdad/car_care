import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_cards.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderProfileFuelPricesSection extends StatelessWidget {
  const ProviderProfileFuelPricesSection({super.key, required this.profile});
  final FuelProviderProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prices = profile.prices ?? {};
    final fuelTypes = profile.fuelTypes ?? prices.keys.toList();

    if (fuelTypes.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProviderProfileSectionTitle(
          title: l10n.providerProfileServicesAndPricesTitle,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            for (var i = 0; i < fuelTypes.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: _FuelPriceCard(
                  fuelType: fuelTypes[i],
                  price: prices[fuelTypes[i]],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _FuelPriceCard extends StatelessWidget {
  const _FuelPriceCard({required this.fuelType, this.price});
  final String fuelType;
  final double? price;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final borderColor = AppColors.carWashTeal;
    final priceText = price != null
        ? l10n.providerProfilePriceLine(price.toString())
        : '-';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              fuelType,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(height: 1, thickness: 1,
                color: borderColor.withValues(alpha: 0.35)),
            SizedBox(height: 8.h),
            Text(
              priceText,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}