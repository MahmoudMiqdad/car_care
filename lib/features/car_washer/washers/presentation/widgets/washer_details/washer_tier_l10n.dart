import 'package:car_care/l10n.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_service_tier.dart';
import 'package:flutter/widgets.dart';

String washerTierLabel(BuildContext context, WasherServiceTier tier) {
  final l10n = context.l10n;
  return switch (tier) {
    WasherServiceTier.basic => l10n.washerTierBasic,
    WasherServiceTier.vip => l10n.washerTierVip,
    WasherServiceTier.premium => l10n.washerTierPremium,
  };
}
