import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/washers/domain/washer_service_tier.dart';
import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherTierBadges extends StatelessWidget {
  const WasherTierBadges({super.key, required this.tiers});

  final List<WasherServiceTier> tiers;

  static String _label(AppLocalizations l10n, WasherServiceTier tier) {
    switch (tier) {
      case WasherServiceTier.basic:
        return l10n.washerTierBasic;
      case WasherServiceTier.vip:
        return l10n.washerTierVip;
      case WasherServiceTier.premium:
        return l10n.washerTierPremium;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tiers.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(tiers.length * 2 - 1, (index) {
        if (index.isOdd) {
          return SizedBox(width: 6.w);
        }

        final tier = tiers[index ~/ 2];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2F6),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Text(
            _label(context.l10n, tier),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }),
    );
  }
}
