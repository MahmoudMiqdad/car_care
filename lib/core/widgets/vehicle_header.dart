import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleHeader extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final String title;
  final TextStyle? titleStyle;
  final Widget? bottomChild;
  final double imageHeight;

  const VehicleHeader({
    super.key,
    required this.imagePath,
    this.isNetworkImage = true,
    required this.title,
    this.titleStyle,
    this.bottomChild,
    this.imageHeight = 130, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          Container(
            height: imageHeight.h,
            width: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r), 
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: _imageContent(),
            ),
          ),
          
          SizedBox(height: 8.h),
                    Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle ??
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: 0.5,
                ),
          ),
          
          if (bottomChild != null) ...[
            bottomChild!,
          ],
        ],
      ),
    );
  }

  Widget _imageContent() {
    if (imagePath.isEmpty) return _placeholder();
        return isNetworkImage
        ? Image.network(
            imagePath,
            fit: BoxFit.cover, 
            errorBuilder: (_, __, ___) => _placeholder(),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF5F7F9),
      child: Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          size: 50.sp,
          color: const Color(0xFF0C5D6E).withOpacity(0.2),
        ),
      ),
    );
  }
}