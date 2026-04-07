import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';

import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_entity_row.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsVehicleSection extends StatelessWidget {
  const OrderDetailsVehicleSection({super.key, required this.model});
  final VehicleEntity model;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'بيانات المركبة',
      child: OrderDetailsEntityRow(
        imageAsset: 'assets/images/icons8-profile-picture-50.png',
        placeholderIcon: Icons.directions_car_outlined,
        avatarSize: AppConstants.vehicleAvatar,
        title: model.brand,
        infoRows: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 5,
                child: OrderDetailsIconLabel(
                  icon: Icons.speed_outlined,
                  label: model.model,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 6,
                child: OrderDetailsIconLabel(
                  imagePath: 'assets/images/number.png',
                  label: model.plateNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
