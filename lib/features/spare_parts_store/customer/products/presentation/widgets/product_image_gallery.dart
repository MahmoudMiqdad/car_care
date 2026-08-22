// معرض صور المنتج بصورة رئيسية وصور مصغّرة (أو Placeholder واحد عند غياب الصور)
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_network_image_widget.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/condition_badge.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({
    super.key,
    required this.images,
    required this.isNew,
  });

  final List<String> images;
  final bool isNew;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ConditionBadge(isNew: widget.isNew),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: hasImages
              ? AppCachedImageWidget(
                  imageUrl: widget.images[_selectedIndex],
                  height: 200.h,
                  clipRadius: 0,
                )
              : const _EmptyImageContent(),
        ),
        if (hasImages && widget.images.length > 1) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 68.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border(context),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: _ThumbnailImage(imageUrl: widget.images[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ThumbnailImage extends StatelessWidget {
  const _ThumbnailImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60.w,
        height: 60.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => ColoredBox(color: AppColors.secondary),
        errorWidget: (context, url, error) => ColoredBox(
          color: AppColors.secondary,
          child: Icon(
            Icons.broken_image_outlined,
            size: 18.sp,
            color: AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }
}

class _EmptyImageContent extends StatelessWidget {
  const _EmptyImageContent();

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.textSecondary(context);
final string =context.l10n;
    return Container(
      width: double.infinity,
      height: 200.h,
      color: AppColors.secondary,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build_circle_outlined, size: 72.sp, color: iconColor),
          SizedBox(height: 8.h),
          Text(
            string.productImageLabel,
            style: context.textTheme.labelSmall!.copyWith(color: iconColor),
          ),
        ],
      ),
    );
  }
}
