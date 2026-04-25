import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/domain/washer_service_tier.dart';

/// Temporary seed data. Swap the list in the page for repository output + Cubit/Bloc.
abstract final class CarWashListingsDevData {
  static const List<CarWashListing> preview = <CarWashListing>[
    CarWashListing(
      id: '1',
      name: 'مغسل المقداد',
      cityName: 'درعا',
      ratingsCount: 122,
      stars: 4.2,
      tiers: <WasherServiceTier>[
        WasherServiceTier.basic,
        WasherServiceTier.vip,
        WasherServiceTier.premium,
      ],
      avatarBackgroundArgb: 0xFFFFFFFF,
      avatarIconArgb: 0xFF0D47A1,
    ),
    CarWashListing(
      id: '2',
      name: 'مغسل الورد',
      cityName: 'دمشق',
      ratingsCount: 40,
      stars: 3,
      tiers: <WasherServiceTier>[WasherServiceTier.premium, WasherServiceTier.vip],
      avatarBackgroundArgb: 0xFF000000,
      avatarIconArgb: 0xFFE53935,
    ),
  ];
}
