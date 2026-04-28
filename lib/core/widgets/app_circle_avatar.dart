import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Circular image with optional network URL; falls back to [placeholderAssetPath].
class AppCircleAvatar extends StatelessWidget {
  const AppCircleAvatar({
    super.key,
    required this.diameter,
    this.networkImageUrl,
    required this.placeholderAssetPath,
  });

  final double diameter;
  final String? networkImageUrl;
  final String placeholderAssetPath;

  @override
  Widget build(BuildContext context) {
    final size = diameter.r;
    final url = networkImageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _AssetImage(
            path: placeholderAssetPath,
            size: size,
          ),
        ),
      );
    }
    return _AssetImage(
      path: placeholderAssetPath,
      size: size,
    );
  }
}

class _AssetImage extends StatelessWidget {
  const _AssetImage({
    required this.path,
    required this.size,
  });

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
