import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/orders/presentation/models/order_details_ui_model.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_section_card.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsMalfunctionSection extends StatelessWidget {
  const OrderDetailsMalfunctionSection({super.key, required this.model});
  final OrderDetailsUiModel model;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'تفاصيل العطل',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageGallery(images: model.issueThumbAssets),          
          SizedBox(height: 16.h),
          AppInfoRow(
            label: 'وصف', 
            value: model.malfunctionDescription, 
            icon: Icons.description_outlined
          ),
          AppInfoRow(label: 'الحالة', value: model.statusLabel),
          AppInfoRow(
            label: 'التاريخ المفضل', 
            value: model.preferredDateLabel, 
            icon: Icons.calendar_month_outlined
          ),
          AppInfoRow(label: 'تاريخ الطلب', value: model.requestDateLabel),
          SizedBox(height: 12.h),
          AppButton(
            text: model.priorityBannerLabel,
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
  final List<String> images;
  const ImageGallery({super.key, required this.images});
  @override
  Widget build(BuildContext context) {
    final gap = AppConstants.issueThumbGap;
    return Row(
      textDirection: TextDirection.rtl,
      children: images.map((path) => Expanded(
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            end: path == images.last ? 0 : gap
          ),
          child: AppImageWidget(
            path: path,
            aspectRatio: 1,
            borderRadius: 10.r,
          ),
        ),
      )).toList(),
    );
  }
}