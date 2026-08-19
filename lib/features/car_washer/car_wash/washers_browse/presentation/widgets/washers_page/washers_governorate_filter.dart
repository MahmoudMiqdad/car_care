import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:flutter/material.dart';

const List<String?> washersGovernorateFilterOptions = [
  null,
  ...kCreateSosProvinceOptions,
];

const String _kAllGovernoratesLabel = 'كل المحافظات';
const String _kFilterTitle = 'حسب المحافظة';


const String _kAllGovernoratesValue = '__all__';

class WashersGovernorateFilter extends StatelessWidget {
  const WashersGovernorateFilter({
    super.key,
    required this.selectedGovernorate,
    required this.onChanged,
  });

  final String? selectedGovernorate;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GenericDropdownFilter<String>(
      options: washersGovernorateFilterOptions
          .map((g) => g ?? _kAllGovernoratesValue)
          .toList(),
      labelBuilder: (value) =>
          value == _kAllGovernoratesValue ? _kAllGovernoratesLabel : value,
      selectedValue: selectedGovernorate,
      triggerLabel: selectedGovernorate ?? _kFilterTitle,
      onChanged: (value) {
        onChanged(value == _kAllGovernoratesValue ? null : value);
      },
    );
  }
}
