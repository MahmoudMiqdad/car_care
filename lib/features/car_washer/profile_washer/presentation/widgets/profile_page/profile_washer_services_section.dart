import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/profile_page/profile_washer_service_tier_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWasherServicesSection extends StatelessWidget {
  const ProfileWasherServicesSection({
    super.key,
    required this.basicPrice,
    required this.vipPrice,
    required this.premiumPrice,
  });

  final String basicPrice;
  final String vipPrice;
  final String premiumPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          l10n.washerSectionServicesAndPrices,
          color: AppColors.black,
          textAlign: TextAlign.right,
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Expanded(
                child: ProfileWasherServiceTierCard(
                  packageName: l10n.profileWasherTierPremium,
                  priceLabel: '${l10n.profileWasherFieldPrice}: $premiumPrice \$',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ProfileWasherServiceTierCard(
                  packageName: l10n.profileWasherTierVip,
                  priceLabel: '${l10n.profileWasherFieldPrice}: $vipPrice \$',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ProfileWasherServiceTierCard(
                  packageName: l10n.profileWasherTierBasic,
                  priceLabel: '${l10n.profileWasherFieldPrice}: $basicPrice \$',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
