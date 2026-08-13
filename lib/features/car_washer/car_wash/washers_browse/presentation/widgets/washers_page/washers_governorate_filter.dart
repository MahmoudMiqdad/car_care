import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:flutter/material.dart';

/// Governorate options in display order — `null` is "كل المحافظات" (clears
/// the filter).
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

/// `PopupMenuButton` treats a `null` return from its menu route as
/// "dismissed without a selection" and calls `onCanceled` instead of
/// `onSelected` (see `showButtonMenu` in the Flutter SDK) — so the "all"
/// option can never use `null` as its actual selectable value. This
/// sentinel stands in for it and is translated back to `null` right here
/// in the wrapper before reaching [WashersGovernorateFilter.onChanged].
/// [GenericDropdownFilter] itself has no notion of this sentinel — it
/// only ever sees plain, opaque `String` options.
const String _kAllGovernoratesValue = '__all__';

/// Governorate filter for the customer washers list — a thin wrapper over
/// the generic, feature-agnostic [GenericDropdownFilter], feeding the
/// existing `city` query param used by `WashersCubit`/`IWashersRepository`
/// — no backend/contract change. All governorate-specific knowledge
/// (the option list, the sentinel translation) lives only in this file.
class WashersGovernorateFilter extends StatelessWidget {
  const WashersGovernorateFilter({
    super.key,
    required this.selectedGovernorate,
    required this.onChanged,
  });

  /// `null` means no governorate filter is applied.
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
