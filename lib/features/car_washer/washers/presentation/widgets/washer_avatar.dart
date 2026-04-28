import 'package:car_care/core/widgets/app_circle_avatar.dart';
import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/washer_image_assets.dart';
import 'package:flutter/material.dart';

class WasherAvatar extends StatelessWidget {
  const WasherAvatar({super.key, required this.listing, this.diameter = 84});

  final CarWashListing listing;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return AppCircleAvatar(
      diameter: diameter,
      networkImageUrl: listing.logoImageUrl,
      placeholderAssetPath: WasherImageAssets.defaultBranchAvatar,
    );
  }
}
