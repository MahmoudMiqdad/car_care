import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_loading_widget.dart';

class AppCachedImageWidget extends StatelessWidget {
  const AppCachedImageWidget({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.clipRadius = 0.0,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double clipRadius;

  @override
  Widget build(BuildContext context) {
    // استخدام الـ Extension
    final colorScheme = context.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(clipRadius == 0 ? 0 : clipRadius.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? double.infinity,
        height: height ?? 200.h,
        fit: fit,
        // استخدام الـ Loading widget الموحد تبعك
        placeholder: (context, url) => Center(
          child: AppLoadingWidget(),
        ),
        errorWidget: (context, url, error) => ColoredBox(
          color: colorScheme.error.withValues(alpha: .1),
          child: Icon(
            Icons.broken_image_outlined,
            color: colorScheme.error,
            size: 30.sp,
          ),
        ),
      ),
    );
  }
}
