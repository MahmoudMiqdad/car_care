import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_entity_row.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_section_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsVehicleSection extends StatelessWidget {
  const OrderDetailsVehicleSection({super.key, required this.model});
  final VehicleEntity model;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OrderDetailsSectionCard(
      title: l10n.vehicleDataTitle,
      child: OrderDetailsEntityRow(
        imageUrl: resolveMediaUrl(model.image),
        placeholderIcon: Icons.directions_car_outlined,
        avatarSize: AppConstants.vehicleAvatar,
        title: model.brand,
        infoRows: [
          Row(
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
