import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherTierBadges extends StatelessWidget {
  const WasherTierBadges({super.key, required this.servicePrices});

  final Map<String, int> servicePrices;

  @override
  Widget build(BuildContext context) {
    if (servicePrices.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;

    const order = <String>['premium', 'vip', 'basic'];
    final tiers = order.where(servicePrices.containsKey).toList();

    String labelOf(String key) {
      switch (key) {
        case 'basic':
          return l10n.washerTierBasic;
        case 'vip':
          return l10n.washerTierVip;
        case 'premium':
          return l10n.washerTierPremium;
        default:
          return key;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(tiers.length * 2 - 1, (index) {
        if (index.isOdd) return SizedBox(width: 6.w);

        final key = tiers[index ~/ 2];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2F6),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Text(
            labelOf(key),
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