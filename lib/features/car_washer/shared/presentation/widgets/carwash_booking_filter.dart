import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
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
    null: l10n.bookingStatusAll,
    'pending': l10n.bookingStatusPending,
    'accepted': l10n.bookingStatusAccepted,
    'in_progress': l10n.bookingStatusProgress,
    'completed': l10n.bookingStatusCompleted,
    'cancelled': l10n.bookingStatusCanceled,
  };
}

/// [StatusFilterTabs] compares tab values with `==`, so "all" needs this
/// non-null stand-in to remain a selectable/highlightable tab value.
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

    final items = carwashBookingFilterStatusKeys
        .map(
          (key) => StatusFilterTabItem<String>(
            value: key ?? _kAllStatusValue,
            label: labelsByKey[key] ?? l10n.bookingStatusAll,
          ),
        )
        .toList();

    return StatusFilterTabs<String>(
      items: items,
      selected: selectedStatus ?? _kAllStatusValue,
      onChanged: (value) {
        onChanged(value == _kAllStatusValue ? null : value);
      },
    );
  }
}
