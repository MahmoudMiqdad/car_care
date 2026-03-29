import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleHeader extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final String title;
  final TextStyle? titleStyle;
  final Widget? bottomChild;
  final double imageSize;
  final double? spacingBetweenTitleAndBottomChild;

  const VehicleHeader({
    super.key,
    required this.imagePath,
    this.isNetworkImage = true,
    required this.title,
    this.titleStyle,
    this.bottomChild,
    this.imageSize = 120,
    this.spacingBetweenTitleAndBottomChild,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3.w),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: ClipOval(
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    width: imageSize.w,
                    height: imageSize.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        width: imageSize.w,
                        height: imageSize.w,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : Image.asset(
                    imagePath,
                    width: imageSize.w,
                    height: imageSize.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle ??
                TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
          ),
        ),
        if (bottomChild != null) ...[
          SizedBox(height: spacingBetweenTitleAndBottomChild ?? 8.h),
          bottomChild!,
        ],
      ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: imageSize.w,
      height: imageSize.w,
      color: Colors.grey[200],
      child: Icon(Icons.directions_car, size: (imageSize / 2).sp, color: Colors.grey),
    );
  }
}