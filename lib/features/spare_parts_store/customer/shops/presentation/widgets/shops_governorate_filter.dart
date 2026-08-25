import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

const String _kAllGovernoratesValue = '__all__';

class ShopsGovernorateFilter extends StatelessWidget {
  const ShopsGovernorateFilter({
    super.key,
    required this.selectedGovernorate,
    required this.onChanged,
  });

  final String? selectedGovernorate;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [_kAllGovernoratesValue, ...kCreateSosProvinceOptions];

    String labelBuilder(String value) =>
        value == _kAllGovernoratesValue ? l10n.allGovernorates : value;

    return GenericDropdownFilter<String>(
      options: options,
      labelBuilder: labelBuilder,
      selectedValue: selectedGovernorate ?? _kAllGovernoratesValue,
      triggerLabel: selectedGovernorate ?? l10n.fuelSosCreateProvinceTitle,
      onChanged: (value) {
        onChanged(value == _kAllGovernoratesValue ? null : value);
      },
    );
  }
}
