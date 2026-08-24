import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderProfileSectionTitle extends StatelessWidget {
  const ProviderProfileSectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: context.textTheme.bodyMedium!.copyWith(
          color: context.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class ProviderProfileTealBorderCard extends StatelessWidget {
  const ProviderProfileTealBorderCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.carWashTeal, width: 1.2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: child,
      ),
    );
  }
}

class ProviderProfileHeader extends StatelessWidget {
  const ProviderProfileHeader({super.key, required this.profile});
  final FuelProviderProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          profile.companyName ?? '-',
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall!.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          profile.phone ?? '-',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ProviderProfileAvailabilityCard extends StatelessWidget {
  const ProviderProfileAvailabilityCard({
    super.key,
    required this.isAvailable,
    required this.onChanged,
  });
  final bool isAvailable;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ProviderProfileTealBorderCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              isAvailable
                  ? l10n.providerProfileAvailableNow
                  : l10n.providerProfileNotAvailableNow,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: isAvailable,
            onChanged: onChanged,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.carWashTeal,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.border(context),
          ),
        ],
      ),
    );
  }
}

class ProviderProfileLocationCard extends StatelessWidget {
  const ProviderProfileLocationCard({super.key, required this.profile});
  final FuelProviderProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final address = [
      profile.city,
      profile.address,
    ].where((e) => e != null && e.isNotEmpty).join(' - ');

    return ProviderProfileTealBorderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.iconLocationPin,
            width: 32.r,
            height: 32.r,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.sectionTitle(
                  context,
                  l10n.washerSectionCityAndAddress,
                  color: AppColors.textPrimary(context),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                Text(
                  address.isEmpty ? '-' : address,
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
