import 'package:car_care/features/orders/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:flutter/material.dart';

class ProblemDescriptionField extends StatelessWidget {
  const ProblemDescriptionField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return RequestsFlowStyles.formTextFieldCard(
      title: 'وصف المشكلة',
      icon: Icons.edit_note,
      hintText: 'يرجى كتابة تفاصيل المشكلة هنا...',
      controller: controller,
      maxLines: 1, 
    );
  }
}