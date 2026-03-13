// ignore_for_file: file_names

import 'package:car_care/features/vehicle/presentation/widgets/VehicleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehiclesList extends StatelessWidget {
  const VehiclesList({super.key, required this.items});

  final List<VehicleItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return VehicleCard(item: items[index]);
      },
    );
  }
}

class VehicleItem {
  const VehicleItem({
    required this.imageAsset,
    required this.name,
    required this.year,
    required this.plateNumber,
    required this.mileage,
  });

  final String imageAsset;
  final String name;
  final String year;
  final String plateNumber;
  final String mileage;
}
