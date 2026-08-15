import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:flutter/material.dart';

const String _kAllGovernoratesValue = '__all__';
const String _kAllGovernoratesLabel = 'كل المحافظات';
const String _kFilterTitle = 'المحافظة';

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
    final options = [_kAllGovernoratesValue, ...kCreateSosProvinceOptions];

    String labelBuilder(String value) =>
        value == _kAllGovernoratesValue ? _kAllGovernoratesLabel : value;

    return GenericDropdownFilter<String>(
      options: options,
      labelBuilder: labelBuilder,
      selectedValue: selectedGovernorate ?? _kAllGovernoratesValue,
      triggerLabel: selectedGovernorate ?? _kFilterTitle,
      onChanged: (value) {
        onChanged(value == _kAllGovernoratesValue ? null : value);
      },
    );
  }
}
