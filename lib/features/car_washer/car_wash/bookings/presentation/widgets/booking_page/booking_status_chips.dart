import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Kept for call-site/test compatibility — delegates to the shared color
/// resolver, no duplicated switch here.
({Color background, Color border}) customerBookingChipStyleFor(String status) =>
    carwashBookingStatusStyleFor(status);

class BookingStatusChips extends StatelessWidget {
  const BookingStatusChips({
    required this.status,
    required this.label,
    super.key,
  });

  /// Canonical status (pending/accepted/in_progress/completed/cancelled).
  final String status;

  /// Arabic display text (e.g. `booking.statusText`) — display only.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [BookingStatusChip(status: status, label: label)],
    );
  }
}

/// Thin wrapper around the shared [CarwashBookingStatusBadge] — keeps this
/// screen's exact original spacing (left padding, font size, vertical
/// padding) with no visual change; the color/shape logic itself lives only
/// in the shared widget.
class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({
    required this.status,
    required this.label,
    super.key,
  });

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w),
      child: CarwashBookingStatusBadge(
        status: status,
        label: label,
        fontSize: 15,
        verticalPadding: 4,
        horizontalPadding: 10,
      ),
    );
  }
}
