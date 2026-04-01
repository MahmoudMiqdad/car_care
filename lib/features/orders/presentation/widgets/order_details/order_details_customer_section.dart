import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/features/orders/presentation/models/order_details_ui_model.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_entity_row.dart';
import 'package:car_care/features/orders/presentation/widgets/order_details/order_details_section_card.dart';
import 'package:flutter/material.dart';

class OrderDetailsCustomerSection extends StatelessWidget {
  const OrderDetailsCustomerSection({super.key, required this.model});
  final OrderDetailsUiModel model;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'بيانات العميل',
      child: OrderDetailsEntityRow(
        imageAsset: model.customerAvatarAsset,
        placeholderIcon: Icons.person,
        avatarSize: AppConstants.customerAvatar,
        title: model.customerName,
        infoRows: [
          OrderDetailsIconLabel(icon: Icons.phone_in_talk_outlined, label: model.customerPhone),
        ],
      ),
    );
  }
}