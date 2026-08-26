import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/filter_drop_down.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/core/service_locator/service_locator.dart';

import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_state.dart';

import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/booking_card.dart';

class CustomerBookingsPage extends StatelessWidget {
  const CustomerBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerBookingsCubit>()..fetchBookings(), 
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.bookingsPageTitle,
          showBackButton: true,
          onBackTapped: () => context.safePopOrGo(Routes.home),
        ),
        backgroundColor: AppColors.scaffoldBackground(context),
        body: ImageBackground(
          child: SafeArea(
            child: BlocBuilder<CustomerBookingsCubit, CustomerBookingsState>(
              builder: (context, state) {
                if (state is CustomerBookingsLoading) {
                  return const Center(child: AppLoadingWidget());
                }
                if (state is CustomerBookingsError) {
                  return Center(
                    child: Text(localizeErrorMessage(context, state.message)),
                  );
                }
                if (state is CustomerBookingsLoaded) {
                  final items = state.items;
      
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 20.h),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, _) => SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      if (index == 0) return  CustomerBookingFilter();
      
                      final booking = items[index - 1];
      
                      return BookingCard(
                        booking: booking,
                      );
                    },
                  );
                }
      
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}