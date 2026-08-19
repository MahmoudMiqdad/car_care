import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:car_care/l10n.dart'; 
import 'package:flutter/material.dart';

class ProblemDescriptionField extends StatelessWidget {
  const ProblemDescriptionField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RequestsFlowStyles.formTextFieldCard(
      context: context,
      title: l10n.problemDescriptionTitle, 
      icon: Icons.edit_note,
      hintText: l10n.problemDescriptionHint, 
      controller: controller,
      maxLines: 1, 
    );
  }
}
