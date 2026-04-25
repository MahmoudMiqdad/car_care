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
      ];
}
