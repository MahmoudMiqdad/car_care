import 'package:car_care/features/car_washer/washers/domain/car_wash_customer_review.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/domain/washer_service_tier.dart';

/// Temporary seed data. Swap the list in the page for repository output + Cubit/Bloc.
abstract final class CarWashListingsDevData {
  static final List<CarWashListing> preview = <CarWashListing>[
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
      phone: '0933111222',
      openTime: '08:00',
      closeTime: '18:00',
      fullAddress: 'درعا — شارع السوق — مقابل الملعب',
      packagePrices: <WasherServiceTier, int>{
        WasherServiceTier.premium: 30,
        WasherServiceTier.vip: 22,
        WasherServiceTier.basic: 12,
      },
      reviews: <CarWashCustomerReview>[
        CarWashCustomerReview(
          authorName: 'نورا علي',
          date: DateTime(2025, 2, 10),
          comment: 'خدمة جيدة وسرعة بالتنفيذ.',
          stars: 4,
        ),
      ],
    ),
    CarWashListing(
      id: '2',
      name: 'مغسل المحبة',
      cityName: 'دمشق',
      ratingsCount: 507,
      stars: 3,
      tiers: <WasherServiceTier>[
        WasherServiceTier.premium,
        WasherServiceTier.vip,
        WasherServiceTier.basic,
      ],
      avatarBackgroundArgb: 0xFF000000,
      avatarIconArgb: 0xFFE53935,
      phone: '0987654321',
      openTime: '10:00',
      closeTime: '20:00',
      fullAddress: 'دمشق - ساحة العباسيين - مدخل ساحة القصور',
      packagePrices: <WasherServiceTier, int>{
        WasherServiceTier.premium: 30,
        WasherServiceTier.vip: 25,
        WasherServiceTier.basic: 15,
      },
      reviews: <CarWashCustomerReview>[
        CarWashCustomerReview(
          authorName: 'احمد احمد',
          date: DateTime(2026, 1, 1),
          comment: 'خدمة ممتازة متكاملة سريعة',
          stars: 3,
        ),
      ],
    ),
  ];
}
