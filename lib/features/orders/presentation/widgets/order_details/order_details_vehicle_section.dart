import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/orders/presentation/models/order_details_ui_model.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_entity_row.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsVehicleSection extends StatelessWidget {
  const OrderDetailsVehicleSection({super.key, required this.model});
  final OrderDetailsUiModel model;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'بيانات المركبة',
      child: OrderDetailsEntityRow(
        imageAsset: model.vehicleImageAsset,
        placeholderIcon: Icons.directions_car_outlined,
        avatarSize: AppConstants.vehicleAvatar,
        title: model.vehicleTitle,
        infoRows: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 5,
                child: OrderDetailsIconLabel(
                  icon: Icons.speed_outlined, 
                  label: model.vehicleKmLabel,
                ),
              ),
              SizedBox(width: 4.w),
                            Expanded(
                flex: 6,
                child: OrderDetailsIconLabel(
                  imagePath: 'assets/images/number.png',
                  label: model.licensePlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}