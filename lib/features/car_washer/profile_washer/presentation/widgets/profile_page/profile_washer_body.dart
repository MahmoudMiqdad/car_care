import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/models/profile_washer_ui_model.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_about_section.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_contact_cards_row.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_header.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_location_card.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_services_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileWasherBody extends StatelessWidget {
  const ProfileWasherBody({super.key, required this.profile});

  final ProfileWasherUiModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileWasherHeader(profile: profile),
          SizedBox(height: 5.h),
          ProfileWasherContactCardsRow(
            phone: profile.phone,
            workStart: profile.workStart,
            workEnd: profile.workEnd,
          ),
          SizedBox(height: 8.h),
          ProfileWasherLocationCard(address: profile.address),
          SizedBox(height: 8.h),
          ProfileWasherAboutSection(description: profile.description),
          SizedBox(height: 8.h),
          ProfileWasherServicesSection(
            basicPrice: profile.basicPrice,
            vipPrice: profile.vipPrice,
            premiumPrice: profile.premiumPrice,
          ),
          SizedBox(height: 24.h),
          AppButton(
            onPressed: () => context.push(Routes.editProfileWasher),
            text: l10n.profileWasherEditProfile,
            backgroundColor: AppColors.orange,
            borderRadius: 28.r,
            height: 54.h,
            fontSize: 20.sp,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
