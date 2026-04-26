import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/washer_image_assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherAvatar extends StatelessWidget {
  const WasherAvatar({super.key, required this.listing, this.diameter = 84});

  final CarWashListing listing;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final url = listing.logoImageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: diameter.r,
          height: diameter.r,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _AssetAvatar(diameter: diameter),
        ),
      );
    }
    return _AssetAvatar(diameter: diameter);
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        WasherImageAssets.defaultBranchAvatar,
        width: diameter.r,
        height: diameter.r,
        fit: BoxFit.cover,
      ),
    );
  }
}
