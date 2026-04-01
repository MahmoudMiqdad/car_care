import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//الصورة الموجود بالشكل المربع مثل سكرينة الاوردر وتفاصيلها 
class AppImageWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? aspectRatio;
  final BoxFit fit;

  const AppImageWidget({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.borderRadius,
    this.aspectRatio,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppColors.lightBorder,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: (width != null ? width! * 0.4 : 30).sp,
          color: AppColors.lightTextSecondary,
        ),
      ),
    );
    if (aspectRatio != null) {
      image = AspectRatio(aspectRatio: aspectRatio!, child: image);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: image,
    );
  }
}