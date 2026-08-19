import 'dart:io';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/add_photo_tile.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/requests_form_card.dart';
import 'package:car_care/l10n.dart'; 
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
    final l10n = context.l10n;

    return RequestsFormCard(
      cardRadius: cardRadius,
      title: l10n.attachPhotos,
      icon: Icons.camera_alt,
      iconColor: AppColors.primary,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${images.length}/3',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary(context),
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
                            color: AppColors.black.withValues(alpha: 0.54), 
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.white,
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
