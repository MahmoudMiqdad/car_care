import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<String?> washerBookingFilterStatusKeys =
    carwashBookingFilterStatusKeys;

class WasherBookingFilter extends StatelessWidget {
  const WasherBookingFilter({super.key});

  @override
  Widget build(BuildContext context) {
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
