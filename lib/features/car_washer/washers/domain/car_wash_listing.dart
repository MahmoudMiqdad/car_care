import 'package:car_care/features/car_washer/washers/domain/car_wash_customer_review.dart';
import 'package:car_care/features/car_washer/washers/domain/washer_service_tier.dart';
import 'package:equatable/equatable.dart';

class CarWashListing extends Equatable {
  const CarWashListing({
    required this.id,
    required this.name,
    required this.cityName,
    required this.ratingsCount,
    required this.stars,
    required this.tiers,
    this.avatarBackgroundArgb,
    this.avatarIconArgb,
    this.logoImageUrl,
    this.phone = '',
    this.openTime = '',
    this.closeTime = '',
    this.fullAddress = '',
    this.reviews = const <CarWashCustomerReview>[],
    this.packagePrices = const <WasherServiceTier, int>{},
  });

  final String id;
  final String name;
  final String cityName;
  final int ratingsCount;
  final double stars;
  final List<WasherServiceTier> tiers;

  final int? avatarBackgroundArgb;
  final int? avatarIconArgb;
  final String? logoImageUrl;

  final String phone;
  final String openTime;
  final String closeTime;
  final String fullAddress;
  final List<CarWashCustomerReview> reviews;
  final Map<WasherServiceTier, int> packagePrices;

  @override
  List<Object?> get props => [
        id,
        name,
        cityName,
        ratingsCount,
        stars,
        tiers,
        avatarBackgroundArgb,
        avatarIconArgb,
        logoImageUrl,
        phone,
        openTime,
        closeTime,
        fullAddress,
        reviews,
        packagePrices,
      ];
}
