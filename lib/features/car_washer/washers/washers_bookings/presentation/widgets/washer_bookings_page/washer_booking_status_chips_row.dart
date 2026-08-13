import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_status_badge.dart';
import 'package:flutter/material.dart';

({Color background, Color border}) washerBookingChipStyleFor(String status) =>
    carwashBookingStatusStyleFor(status);

class WasherBookingStatusChipsRow extends StatelessWidget {
  const WasherBookingStatusChipsRow({
    super.key,
    required this.status,
    required this.label,
  });

  final String status;
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
