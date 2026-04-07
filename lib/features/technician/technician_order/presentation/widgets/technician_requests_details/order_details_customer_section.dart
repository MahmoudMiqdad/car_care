import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/technician/technician_order/domain/entities/request_entity.dart';


import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_entity_row.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/order_details_section_card.dart';
import 'package:flutter/material.dart';

class OrderDetailsCustomerSection extends StatelessWidget {
  const OrderDetailsCustomerSection({super.key, required this.model});
  final CustomerEntity model;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'بيانات العميل',
      child: OrderDetailsEntityRow(
         imageAsset: 'assets/images/icons8-profile-picture-50.png',
        placeholderIcon: Icons.person,
        avatarSize: AppConstants.customerAvatar,
        title: model.name,
        infoRows: [
          OrderDetailsIconLabel(icon: Icons.phone_in_talk_outlined, label: model.phone),
        ],
      ),
    );
  }
}