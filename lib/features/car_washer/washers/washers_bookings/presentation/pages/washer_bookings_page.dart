import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_card.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:car_care/core/service_locator/service_locator.dart';

class WasherBookingsPage extends StatelessWidget {
  const WasherBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>()..fetchBookings(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.bookingsPageTitle,
          showBackButton: true,
          onBackTapped: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.more);
            }
          },
        ),
        backgroundColor: AppColors.scaffoldBackground(context),
        body: ImageBackground(
          child: SafeArea(
            child: BlocConsumer<BookingsCubit, BookingsState>(
              listener: (context, state) {
                if (state is BookingActionSuccessMessage) {
                  AppSnackBar.success(
                    context,
                    state.message.isEmpty
                        ? context.l10n.actionCompletedSuccess
                        : state.message,
                  );
                }
                if (state is BookingActionError) {
                  AppSnackBar.error(context, localizeErrorMessage(context, state.message));
                }
              },
              builder: (context, state) {
                if (state is BookingsLoading || state is BookingsInitial) {
                  return const Center(child: AppLoadingWidget());
                }
                if (state is BookingsError) {
                  return Center(
                    child: Text(localizeErrorMessage(context, state.message)),
                  );
                }

                List<BookingsEntity>? realBookings;
                Set<int> busyBookingIds = const {};
                if (state is BookingsLoaded) {
                  realBookings = state.items;
                  busyBookingIds = state.busyBookingIds;
                } else if (state is BookingActionLoading) {
                  realBookings = state.currentItems;
                  busyBookingIds = state.busyBookingIds;
                } else if (state is BookingActionSuccessMessage) {
                  realBookings = state.currentItems;
                  busyBookingIds = state.busyBookingIds;
                } else if (state is BookingActionError) {
                  realBookings = state.currentItems;
                  busyBookingIds = state.busyBookingIds;
                }

                if (realBookings == null) return const SizedBox.shrink();
                final items = realBookings;

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
                  itemCount: items.length + 1 + (items.isEmpty ? 1 : 0),
                  separatorBuilder: (_, index) => SizedBox(height: 14.h),
                  itemBuilder: (context, index) {
                    if (index == 0) return const WasherBookingFilter();
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: EmptyStateWidget(),
                      );
                    }
                    final booking = items[index - 1];
                    return WasherBookingCard(
                      booking: booking,
                      busy: busyBookingIds.contains(booking.id),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
