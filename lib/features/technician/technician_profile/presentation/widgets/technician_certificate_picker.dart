import 'dart:io';

import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

/// Certificate pick/cap/thumbnail/remove grid shared by Create and Edit.
/// Controlled component: the parent owns the [XFile] list (needed for the
/// multipart `certifications[i]` submit payload) and is notified of the
/// full updated list on every pick/remove.
class TechnicianCertificatePicker extends StatelessWidget {
  const TechnicianCertificatePicker({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxCount = 3,
  });

  final List<XFile> images;
  final ValueChanged<List<XFile>> onImagesChanged;
  final int maxCount;

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;

    if (picked.length + images.length > maxCount) {
      // ignore: use_build_context_synchronously
      AppSnackBar.error(context, 'يمكنك اختيار $maxCount صور كحد أقصى');
      return;
    }

    onImagesChanged([...images, ...picked]);
  }

  void _removeImage(XFile image) {
    onImagesChanged(images.where((i) => i != image).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        ...images.map(
          (image) => _CertificateThumbnail(
            image: image,
            onRemove: () => _removeImage(image),
          ),
        ),
        if (images.length < maxCount)
          _AddCertificateTile(onTap: () => _pickImages(context)),
      ],
    );
  }
}

class _CertificateThumbnail extends StatelessWidget {
  const _CertificateThumbnail({required this.image, required this.onRemove});

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.file(
            File(image.path),
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16.r),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddCertificateTile extends StatelessWidget {
  const _AddCertificateTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.grey.shade500,
              size: 24.r,
            ),
            SizedBox(height: 4.h),
            Text(
              'إضافة',
              style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
