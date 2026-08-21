import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

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
    final l10n = context.l10n;

    final String kAllGovernoratesLabel = l10n.allGovernorates;
    final String kFilterTitle = l10n.filterByGovernorate;

    final List<String> options = [
      _kAllGovernoratesValue,
      l10n.damascus,
      l10n.rifDimashq,
      l10n.aleppo,
      l10n.homs,
      l10n.hama,
      l10n.latakia,
      l10n.tartus,
      l10n.idlib,
      l10n.daraa,
      l10n.asSuwayda,
      l10n.quneitra,
      l10n.deirEzZor,
      l10n.raqqa,
      l10n.alHasakah,
    ];

    return GenericDropdownFilter<String>(
      options: options,
      labelBuilder: (value) =>
          value == _kAllGovernoratesValue ? kAllGovernoratesLabel : value,
      selectedValue: selectedGovernorate,
      triggerLabel: selectedGovernorate ?? kFilterTitle,
      onChanged: (value) {
        onChanged(value == _kAllGovernoratesValue ? null : value);
      },
    );
  }
}
