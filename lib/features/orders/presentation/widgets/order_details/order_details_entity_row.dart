import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsEntityRow extends StatelessWidget {
  final String imageAsset;
  final IconData placeholderIcon;
  final double avatarSize;
  final String title;
  final List<Widget> infoRows;

  const OrderDetailsEntityRow({
    super.key,
    required this.imageAsset,
    required this.placeholderIcon,
    required this.avatarSize,
    required this.title,
    required this.infoRows,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundColor: AppColors.lightBorder,
          child: ClipOval(
            child: Image.asset(
              imageAsset,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                placeholderIcon,
                size: (avatarSize * 0.6).sp,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: AppConstants.titleSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 6.h),
              ...infoRows,
            ],
          ),
        ),
      ],
    );
  }
}

class OrderDetailsIconLabel extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;

  const OrderDetailsIconLabel({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              width: AppConstants.iconSize,
              height: AppConstants.iconSize,
              color: AppColors.primary,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            )
          else if (icon != null)
            Icon(
              icon,
              size: AppConstants.iconSize,
              color: AppColors.primary,
            ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppConstants.secondarySize,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}