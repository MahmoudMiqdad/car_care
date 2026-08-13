import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

({Color background, Color border}) customerBookingChipStyleFor(String status) =>
    carwashBookingStatusStyleFor(status);

class BookingStatusChips extends StatelessWidget {
  const BookingStatusChips({
    required this.status,
    required this.label,
    super.key,
  });

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [BookingStatusChip(status: status, label: label)],
    );
  }
}

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
