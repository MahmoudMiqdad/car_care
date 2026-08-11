import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_status_badge.dart';
import 'package:flutter/material.dart';

/// Kept for call-site/test compatibility — delegates to the shared color
/// resolver, no duplicated switch here.
({Color background, Color border}) washerBookingChipStyleFor(String status) =>
    carwashBookingStatusStyleFor(status);

/// Thin wrapper around the shared [CarwashBookingStatusBadge] — keeps this
/// screen's exact original spacing (font size, vertical padding) with no
/// visual change; the color/shape logic itself lives only in the shared
/// widget.
class WasherBookingStatusChipsRow extends StatelessWidget {
  const WasherBookingStatusChipsRow({
    super.key,
    required this.status,
    required this.label,
  });

  /// Canonical status (pending/accepted/in_progress/completed/cancelled) —
  /// drives the color.
  final String status;

  /// Arabic display text (e.g. `booking.statusText`) — display only.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CarwashBookingStatusBadge(
          status: status,
          label: label,
          fontSize: 14,
          verticalPadding: 2,
          horizontalPadding: 10,
        ),
      ],
    );
  }
}
