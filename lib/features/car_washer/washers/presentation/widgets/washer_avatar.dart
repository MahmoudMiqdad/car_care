import 'package:car_care/core/widgets/app_circle_avatar.dart';
import 'package:car_care/features/car_washer/washers/presentation/washer_image_assets.dart';
import 'package:flutter/material.dart';

class WasherAvatar extends StatelessWidget {
  const WasherAvatar({super.key, required this.logoUrl, this.diameter = 84});

  final String? logoUrl;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return AppCircleAvatar(
      diameter: diameter,
      networkImageUrl: logoUrl,
      placeholderAssetPath: WasherImageAssets.defaultBranchAvatar,
    );
  }
}