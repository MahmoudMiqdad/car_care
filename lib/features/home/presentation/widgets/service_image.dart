import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ServiceImage extends StatelessWidget {
  const ServiceImage({super.key, 
    required this.path,
    required this.width,
    required this.height,
  });

  final String path;
  final double width;
  final double height;

  bool get _isNetwork =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return AppCachedImageWidget(
        imageUrl: path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        clipRadius: 20,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_not_supported_outlined,
        size: 32.sp,
        color: AppColors.primary.withValues(alpha: 0.45),
      ),
    );
  }
}