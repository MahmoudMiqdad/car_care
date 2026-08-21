import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_about_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_contact_cards_row.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_header.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_location_card.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_services_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/washer_availability_switch_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileWasherBody extends StatelessWidget {
  const ProfileWasherBody({super.key, required this.profile});

  final WasherProfileEntity profile;

  String _firstStart(Map<String, String> hours) {
    if (hours.isEmpty) return '--:--';
    final range = hours.values.first;
    final parts = range.split('-');
    return parts.isNotEmpty ? parts.first.trim() : '--:--';
  }

  String _firstEnd(Map<String, String> hours) {
    if (hours.isEmpty) return '--:--';
    final range = hours.values.first;
    final parts = range.split('-');
    return parts.length > 1 ? parts[1].trim() : '--:--';
  }

  String _price(Map<String, int> prices, String key) {
    final v = prices[key];
    return (v ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileWasherHeader(profile: profile),
            SizedBox(height: 5.h),
            ProfileWasherContactCardsRow(
              phone: profile.phone,
              workStart: _firstStart(profile.workingHours),
              workEnd: _firstEnd(profile.workingHours),
            ),
            SizedBox(height: 8.h),
            ProfileWasherLocationCard(
              address: profile.address.contains(profile.city)
                  ? profile.address
                  : '${profile.city} - ${profile.address}',
            ),
            SizedBox(height: 8.h),
            ProfileWasherAboutSection(description: profile.description),
            SizedBox(height: 8.h),
            ProfileWasherServicesSection(
              basicPrice: _price(profile.servicePrices, 'basic'),
              vipPrice: _price(profile.servicePrices, 'vip'),
              premiumPrice: _price(profile.servicePrices, 'premium'),
            ),
            SizedBox(height: 8.h),
            WasherAvailabilitySwitchCard(initialValue: profile.isAvailable),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () async {
                final result = await context.push(Routes.editProfileWasher);
                if (result == true && context.mounted) {
                  context.read<ProfileWasherCubit>().load();
                }
              },
              text: l10n.profileWasherEditProfile,
              backgroundColor: AppColors.accent,
              borderRadius: 28.r,
              height: 54.h,
              fontSize: 20.sp,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
