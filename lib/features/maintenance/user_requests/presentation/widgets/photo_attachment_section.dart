import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_photo_tile.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoAttachmentSection extends StatelessWidget {
  const PhotoAttachmentSection({
    super.key,
    required this.cardRadius,
    required this.photoCount,
    required this.onAddPhoto,
  });

  final double cardRadius;
  final int photoCount;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return RequestsFormCard(
      cardRadius: cardRadius,
      title: 'إرفاق صور',
      icon: Icons.camera_alt,
      iconColor: AppColors.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$photoCount/3',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const Spacer(),
          AddPhotoTile(cardRadius: cardRadius, onTap: onAddPhoto),
        ],
      ),
    );
  }
}
