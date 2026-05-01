import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_service_tier.dart';

String _tierKey(WasherServiceTier tier) {
  return switch (tier) {
    WasherServiceTier.basic => 'basic',
    WasherServiceTier.vip => 'vip',
    WasherServiceTier.premium => 'premium',
  };
}

int reservationTierPriceUsd(WasherEntity washer, WasherServiceTier tier) {
  final key = _tierKey(tier);
  return washer.servicePrices[key] ?? 0;
}

const List<WasherServiceTier> kReservationTierDisplayOrder = <WasherServiceTier>[
  WasherServiceTier.premium,
  WasherServiceTier.vip,
  WasherServiceTier.basic,
];

List<WasherServiceTier> reservationTiersToShow(WasherEntity washer) {
  final available = kReservationTierDisplayOrder
      .where((t) => washer.servicePrices.containsKey(_tierKey(t)))
      .toList(growable: false);

  return available.isNotEmpty ? available : List.from(kReservationTierDisplayOrder);
}