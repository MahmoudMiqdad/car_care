import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_state.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<String?> customerBookingFilterStatusKeys =
    carwashBookingFilterStatusKeys;

class CustomerBookingFilter extends StatelessWidget {
  const CustomerBookingFilter({super.key});

  @override
  Widget build(BuildContext context) {
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
