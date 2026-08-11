import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kept for call-site/test compatibility — same list as
/// [carwashBookingFilterStatusKeys].
const List<String?> washerBookingFilterStatusKeys =
    carwashBookingFilterStatusKeys;

/// Thin wrapper: reads the current filter from [BookingsCubit] and forwards
/// selection to it. All shape/labels/behavior live in the shared
/// [CarwashBookingFilter] — this file no longer duplicates it.
class WasherBookingFilter extends StatelessWidget {
  const WasherBookingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // Selection is read from the cubit (not local widget state) so it
    // always reflects the truth currently shown.
    return BlocBuilder<BookingsCubit, BookingsState>(
      buildWhen: (previous, current) => current is BookingsLoaded,
      builder: (context, state) {
        final selected = (state is BookingsLoaded && state.status != 'all')
            ? state.status
            : null;

        return CarwashBookingFilter(
          selectedStatus: selected,
          onChanged: (status) =>
              context.read<BookingsCubit>().fetchBookings(status: status),
        );
      },
    );
  }
}
