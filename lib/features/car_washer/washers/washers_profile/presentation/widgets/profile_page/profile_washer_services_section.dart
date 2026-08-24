import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_service_tier_card.dart';
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
          context,
          l10n.washerSectionServicesAndPrices,
          color: context.colorScheme.onSurface,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ProfileWasherServiceTierCard(
                packageName: l10n.profileWasherTierPremium,
                priceLabel:
                    '${l10n.profileWasherFieldPrice}: ${l10n.currencyFormat(premiumPrice)}',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ProfileWasherServiceTierCard(
                packageName: l10n.profileWasherTierVip,
                priceLabel:
                    '${l10n.profileWasherFieldPrice}: ${l10n.currencyFormat(vipPrice)}',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ProfileWasherServiceTierCard(
                packageName: l10n.profileWasherTierBasic,
                priceLabel:
                    '${l10n.profileWasherFieldPrice}: ${l10n.currencyFormat(basicPrice)}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
