import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_state.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kept for call-site/test compatibility — same list as
/// [carwashBookingFilterStatusKeys].
const List<String?> customerBookingFilterStatusKeys =
    carwashBookingFilterStatusKeys;

/// Thin wrapper: reads the current filter from [CustomerBookingsCubit] and
/// forwards selection to it. All shape/labels/behavior live in the shared
/// [CarwashBookingFilter] — this file no longer duplicates it.
class CustomerBookingFilter extends StatelessWidget {
  const CustomerBookingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // Selection is read from the cubit (not local widget state) so it
    // always reflects the truth — including after returning from the
    // details page — instead of drifting out of sync with it.
    return BlocBuilder<CustomerBookingsCubit, CustomerBookingsState>(
      buildWhen: (previous, current) => current is CustomerBookingsLoaded,
      builder: (context, state) {
        final selected = state is CustomerBookingsLoaded ? state.status : null;

        return CarwashBookingFilter(
          selectedStatus: selected,
          onChanged: (status) => context
              .read<CustomerBookingsCubit>()
              .fetchBookings(status: status),
        );
      },
    );
  }
}
