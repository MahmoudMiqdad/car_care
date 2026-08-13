import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:flutter/material.dart';

const List<String?> washersGovernorateFilterOptions = [
  null,
  'دمشق',
  'ريف دمشق',
  'حلب',
  'حمص',
  'حماة',
  'اللاذقية',
  'طرطوس',
  'إدلب',
  'درعا',
  'السويداء',
  'القنيطرة',
  'دير الزور',
  'الرقة',
  'الحسكة',
];

const String _kAllGovernoratesLabel = 'كل المحافظات';
const String _kFilterTitle = 'حسب المحافظة';

/// [GenericDropdownFilter] treats a null `selectedValue` as "nothing
/// selected" regardless of the options list, so "all" needs this non-null
/// stand-in to remain selectable/highlightable.
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
