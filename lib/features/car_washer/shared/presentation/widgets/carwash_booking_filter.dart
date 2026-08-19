import 'package:car_care/core/widgets/filters/generic_dropdown_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

const List<String?> carwashBookingFilterStatusKeys = [
  null,
  'pending',
  'accepted',
  'in_progress',
  'completed',
  'cancelled',
];

Map<String?, String> carwashBookingFilterLabels(AppLocalizations l10n) {
  return {
    null: l10n.all,
    'pending': l10n.bookingStatusPending,
    'accepted': l10n.bookingStatusAccepted,
    'in_progress': l10n.bookingStatusProgress,
    'completed': l10n.bookingStatusCompleted,
    'cancelled': l10n.bookingStatusCanceled,
  };
}

/// [GenericDropdownFilter] treats a null `selectedValue` as "nothing
/// selected" regardless of the options list, so "all" needs this non-null
/// stand-in to remain selectable/highlightable.
const String _kAllStatusValue = '__all__';

class CarwashBookingFilter extends StatelessWidget {
  const CarwashBookingFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelsByKey = carwashBookingFilterLabels(l10n);

    String labelOf(String value) =>
        labelsByKey[value == _kAllStatusValue ? null : value] ?? 'الكل';

    final options = carwashBookingFilterStatusKeys
        .map((key) => key ?? _kAllStatusValue)
        .toList();
    final selectedValue = selectedStatus ?? _kAllStatusValue;

    return GenericDropdownFilter<String>(
      options: options,
      labelBuilder: labelOf,
      selectedValue: selectedValue,
      triggerLabel: labelOf(selectedValue),
      onChanged: (value) {
        onChanged(value == _kAllStatusValue ? null : value);
      },
    );
  }
}
