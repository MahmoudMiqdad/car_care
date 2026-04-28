import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/domain/washer_service_tier.dart';

int reservationTierPriceUsd(CarWashListing listing, WasherServiceTier tier) {
  final p = listing.packagePrices[tier];
  if (p != null) {
    return p;
  }
  return switch (tier) {
    WasherServiceTier.premium => 30,
    WasherServiceTier.vip => 20,
    WasherServiceTier.basic => 10,
  };
}

const List<WasherServiceTier> kReservationTierDisplayOrder = <WasherServiceTier>[
  WasherServiceTier.premium,
  WasherServiceTier.vip,
  WasherServiceTier.basic,
];

List<WasherServiceTier> reservationTiersToShow(CarWashListing listing) {
  final ordered = kReservationTierDisplayOrder
      .where((WasherServiceTier t) => listing.tiers.contains(t))
      .toList(growable: false);
  if (ordered.isNotEmpty) {
    return ordered;
  }
  return List<WasherServiceTier>.from(kReservationTierDisplayOrder);
}
