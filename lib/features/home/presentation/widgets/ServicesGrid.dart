// ignore_for_file: file_names
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/features/home/presentation/widgets/service_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesGrid extends StatelessWidget {
   ServicesGrid({
    super.key,
    this.onItemPressed,
  });
  final ValueChanged<int>? onItemPressed;
  @override
  Widget build(BuildContext context) {
       
 final strings = context.l10n;
 

  final List<ServiceItemData> _items = [
     ServiceItemData(
      title: strings.myVehicles,
      imagePath: AppAssets.serviceMyVehicles,
    ),
     ServiceItemData(
      title: strings.maintenance,
      imagePath: AppAssets.serviceMaintenance,
    ),
     ServiceItemData(
      title:strings.carWash,
      imagePath: AppAssets.serviceCarWash,
    ),
     ServiceItemData(
      title: strings.sos,
      imagePath: AppAssets.serviceSos,
    ),
     ServiceItemData(
      title:strings.marketplace,
      imagePath: AppAssets.serviceMarketplace,
    ),
     ServiceItemData(
      title: strings.fuel,
      imagePath: AppAssets.serviceFuel,
    ),
  ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      itemCount: _items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 118.h,
      ),
      itemBuilder: (context, index) {
        final item = _items[index];
        return ServiceCard(
          item: item,
          onPressed: () => onItemPressed?.call(index),
        );
      },
    );
  }
}

class ServiceItemData {
  const ServiceItemData({
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;
}

