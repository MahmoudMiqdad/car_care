import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_section_card.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OrderDetailsMalfunctionSection extends StatelessWidget {
  const OrderDetailsMalfunctionSection({super.key, required this.model});
  final RequestDataEntity model;
  static String _formatDate(DateTime d) =>
      '${d.year}/${d.month}/${d.day}  ';

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'تفاصيل العطل',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageGallery(images: model.images),
          SizedBox(height: 16.h),
          AppInfoRow(
            label: 'وصف',
            value: model.description,
            icon: Icons.description_outlined,
          ),
          AppInfoRow(
            label: 'الحالة',
            value: model.statusText,

            icon: IconsaxPlusLinear.status,
          ),
          AppInfoRow(
            label: 'تاريخ الطلب',
            value: _formatDate(model.createdAt),
            icon: IconsaxPlusLinear.calendar_add,
          ),
          AppInfoRow(
            label: 'التاريخ المفضل',
            value: _formatDate(model.preferredDate),
            icon: IconsaxPlusLinear.calendar,
          ),
          SizedBox(height: 12.h),
          AppButton(
            text: model.priorityText,
            onPressed: () {},
            backgroundColor: AppColors.error,
            textColor: AppColors.error,
            isOutline: true,
            height: 45.h,
            fontSize: 15.sp,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }
}

class ImageGallery extends StatelessWidget {
  final List<ImageEntity> images;
  const ImageGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) =>
                    Dialog(child: Image.network(image.url, fit: BoxFit.cover)),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                right: index == images.length - 1 ? 0 : 10.w,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AppImageWidget(
                  path: image.url,
                  width: 100.w,
                  height: 100.h,
                  aspectRatio: 1,
                  borderRadius: 10.r,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
