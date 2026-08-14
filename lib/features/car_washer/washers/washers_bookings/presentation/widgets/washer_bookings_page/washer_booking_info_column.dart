import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherBookingInfoColumn extends StatelessWidget {
  const WasherBookingInfoColumn({super.key, required this.booking});

  final BookingsEntity booking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WasherBookingInfoLine(
          label: l10n.washerBookingCustomerNameLabel,
          value: booking.vehicle.ownerName ?? '---',
          boldValue: true,
        ),
        WasherBookingInfoLine(
          label: l10n.washerBookingRequestedServiceLabel,
          value: booking.serviceType,
          boldValue: true,
        ),
        WasherBookingInfoLine(
          label: l10n.washerBookingAppointmentLabel,
          value: booking.scheduledAt,
          boldValue: true,
        ),
        WasherBookingInfoLine(
          label: '${l10n.bookingsPriceLabel} :',
          value: '\$${booking.price ?? '0'}',
          boldValue: true,
        ),
        WasherBookingInfoLine(
          label: '${l10n.bookingDetailsVehicleLabel} :',
          value: '${booking.vehicle.brand} ${booking.vehicle.model}',
        ),
        WasherBookingInfoLine(
          label: '${l10n.plate} :',
          value: booking.vehicle.plateNumber,
        ),
      ],
    );
  }
}

class WasherBookingInfoLine extends StatelessWidget {
  const WasherBookingInfoLine({
    super.key,
    required this.label,
    required this.value,
    this.boldValue = false,
  });

  final String label;
  final String value;
  final bool boldValue;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w900,
          height: 1.5,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
