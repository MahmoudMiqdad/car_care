import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';
import 'package:car_care/features/technician/technician_order/domain/maper/available_map.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_section_card.dart';
import 'package:car_care/core/widgets/app_image_widget.dart';
import 'package:car_care/core/widgets/app_info_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OrderDetailsMalfunctionSection extends StatelessWidget {
  const OrderDetailsMalfunctionSection({super.key, required this.model});
  final RequestDataEntity model;
  
  static String _formatDate(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final priority = model.priority.toPriority();
    
    // 💡 قمنا بتمرير الـ context هنا لحل المشكلة
    final priorityStyle = PriorityChipStyle.forState(
      context: context,
      value: priority,
      selected: priority,
    );

    return OrderDetailsSectionCard(
      title: l10n.malfunctionDetailsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageGallery(images: model.images),
          SizedBox(height: 16.h),
          AppInfoRow(
            label: l10n.descriptionLabel,
            value: model.description,
            leading: Icon(Icons.description_outlined, size: 18.sp, color: Theme.of(context).primaryColor),
          ),
          AppInfoRow(
            label: l10n.statusLabel,
            value: model.statusText,
            leading: Icon(IconsaxPlusLinear.status, size: 18.sp, color: Theme.of(context).primaryColor),
          ),
          AppInfoRow(
            label: l10n.requestDateLabel,
            value: _formatDate(model.createdAt),
            leading: Icon(IconsaxPlusLinear.calendar_add, size: 18.sp, color: Theme.of(context).primaryColor),
          ),
          AppInfoRow(
            label: l10n.preferredDateLabel,
            value: _formatDate(model.preferredDate),
            leading: Icon(IconsaxPlusLinear.calendar, size: 18.sp, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 12.h),
          AppButton(
            text: model.priorityText,
            onPressed: () {},
            backgroundColor: priorityStyle.borderColor,
            textColor: priorityStyle.textColor,
            isOutline: true,
            height: 45.h,
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
              margin: EdgeInsetsDirectional.only(
                end: index == images.length - 1 ? 0 : 10.w,
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
