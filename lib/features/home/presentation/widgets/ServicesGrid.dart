// ignore_for_file: file_names
import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/features/home/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({
    super.key,
    this.onItemPressed,
  });

  final ValueChanged<int>? onItemPressed;

  static final List<ServiceItemData> _items = [
    const ServiceItemData(
      title: 'My Vehicles',
      imagePath: AppAssets.serviceMyVehicles,
    ),
    const ServiceItemData(
      title: 'Maintenace',
      imagePath: AppAssets.serviceMaintenance,
    ),
    const ServiceItemData(
      title: 'CarWash',
      imagePath: AppAssets.serviceCarWash,
    ),
    const ServiceItemData(
      title: 'SOS',
      imagePath: AppAssets.serviceSos,
    ),
    const ServiceItemData(
      title: 'Market place',
      imagePath: AppAssets.serviceMarketplace,
    ),
    const ServiceItemData(
      title: 'Fuel',
      imagePath: AppAssets.serviceFuel,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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

