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

    final governorateLabels = <String, String>{
      'دمشق': l10n.damascus,
      'ريف دمشق': l10n.rifDimashq,
      'حلب': l10n.aleppo,
      'حمص': l10n.homs,
      'حماة': l10n.hama,
      'اللاذقية': l10n.latakia,
      'طرطوس': l10n.tartus,
      'دير الزور': l10n.deirEzZor,
      'الرقة': l10n.raqqa,
      'الحسكة': l10n.alHasakah,
      'درعا': l10n.daraa,
      'السويداء': l10n.asSuwayda,
      'القنيطرة': l10n.quneitra,
      'إدلب': l10n.idlib,
    };

    String labelBuilder(String value) {
      if (value == _kAllGovernoratesValue) return l10n.allGovernorates;
      return governorateLabels[value] ?? value;
    }

    return GenericDropdownFilter<String>(
      options: options,
      labelBuilder: labelBuilder,
      selectedValue: selectedGovernorate ?? _kAllGovernoratesValue,
      triggerLabel: selectedGovernorate != null
          ? labelBuilder(selectedGovernorate!)
          : l10n.fuelSosCreateProvinceTitle,
      onChanged: (value) {
        onChanged(value == _kAllGovernoratesValue ? null : value);
      },
    );
  }
}
