import 'dart:io';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/add_photo_tile.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/requests_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAttachmentSection extends StatelessWidget {
  const PhotoAttachmentSection({
    super.key,
    required this.cardRadius,
    required this.images,
    required this.onAddPhoto,
    required this.onRemove,
  });

  final double cardRadius;
  final List<XFile> images;
  final VoidCallback onAddPhoto;
  final Function(XFile) onRemove;

  @override
  Widget build(BuildContext context) {
    return RequestsFormCard(
      cardRadius: cardRadius,
      title: 'إرفاق صور',
      icon: Icons.camera_alt,
      iconColor: AppColors.primary,
      child: Column(
        children: [
          /// الصف الأساسي (نفس تصميمك)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${images.length}/3',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              if (images.length < 3)
                AddPhotoTile(
                  cardRadius: cardRadius,
                  onTap: onAddPhoto,
                ),
            ],
          ),

          /// 👇 عرض الصور بدون ما نغير التصميم الأساسي
          if (images.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: images.map((image) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(image.path),
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => onRemove(image),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}