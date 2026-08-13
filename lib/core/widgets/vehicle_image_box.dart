import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Prefers `image`, falling back to `imagePath` only when `image` is
/// null/blank — an empty (but non-null) `image` must not win over a real
/// `imagePath`. Single source of truth: every screen that needs to pick a
/// vehicle's raw image field calls this instead of its own `??` check.
String? vehicleImageRawValue(String? image, String? imagePath) {
  final trimmedImage = image?.trim();
  if (trimmedImage != null && trimmedImage.isNotEmpty) return trimmedImage;
  final trimmedPath = imagePath?.trim();
  if (trimmedPath != null && trimmedPath.isNotEmpty) return trimmedPath;
  return null;
}

/// The single source of truth for the vehicle-photo shape across the app:
/// a full-width horizontal banner, matching exactly the geometry of the
/// Home advertisements banner (`AdvertisementCard`/`AdvertisementCarousel`,
/// as wired in `HomeBody`: `height: 160`, `borderRadius: 16`, full width
/// inside the caller's own horizontal padding — no extra margin here).
///
/// Deliberately takes no width/height/radius from callers: every consumer
/// gets the exact same banner, not a per-screen variant.
class VehicleImageBox extends StatelessWidget {
  const VehicleImageBox({super.key, required this.imageUrl});

  /// Same fixed values as the live Home banner (see class doc).
  static const double _height = 160;
  static const double _borderRadius = 16;

  /// A fully-resolved URL (already passed through `resolveMediaUrl` by the
  /// caller) or null/empty — either shows the placeholder.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius.r),
      child: SizedBox(
        width: double.infinity,
        height: _height.h,
        child: _content(),
      ),
    );
  }

  Widget _content() {
    final url = imageUrl;
    if (url == null || url.isEmpty) return _placeholder();
    return Image.network(
      url,
      width: double.infinity,
      height: _height.h,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF5F7F9),
      child: Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          size: 50.sp,
          color: const Color(0xFF0C5D6E).withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
