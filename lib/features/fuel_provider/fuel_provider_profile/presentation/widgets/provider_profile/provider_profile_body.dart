import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_cards.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_fuel_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderProfileBody extends StatelessWidget {
  const ProviderProfileBody({
    super.key,
    required this.profile,
    required this.isAvailable,
    required this.onAvailabilityChanged,
    this.onEditProfile,
  });

  final FuelProviderProfileEntity profile;
  final bool isAvailable;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppConstants.pageHorizontal, 16.h,
          AppConstants.pageHorizontal, 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProviderProfileHeader(profile: profile),
            SizedBox(height: 20.h),
            ProviderProfileSectionTitle(
              title: l10n.providerProfileAvailabilityTitle,
            ),
            SizedBox(height: 8.h),
            ProviderProfileAvailabilityCard(
              isAvailable: isAvailable,
              onChanged: onAvailabilityChanged,
            ),
            SizedBox(height: 14.h),
            ProviderProfileSectionTitle(
              title: l10n.providerProfileLocationSectionTitle,
            ),
            SizedBox(height: 8.h),
            ProviderProfileLocationCard(profile: profile),
            SizedBox(height: 14.h),
            ProviderProfileFuelPricesSection(profile: profile),
            SizedBox(height: 24.h),
            AppButton(
              onPressed: onEditProfile ?? () {},
              text: l10n.profileWasherEditProfile,
              backgroundColor: AppColors.orange,
              borderRadius: 28.r,
              height: 54.h,
              fontSize: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
} 