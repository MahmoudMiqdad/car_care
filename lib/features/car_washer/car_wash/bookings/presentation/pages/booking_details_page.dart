import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';

import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_state.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_details_page/action_buttons.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_details_page/details_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, required this.booking});
  final BookingsEntity? booking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    final vehicleImageUrl = resolveMediaUrl(
      vehicleImageRawValue(booking!.vehicle.image, booking!.vehicle.imagePath),
    );

    final serviceLines = [
      '${l10n.bookingDetailsWasherNameLabel}:  ${booking!.vehicle.ownerName ?? l10n.unknownStatus}',
      '${l10n.bookingsServiceLabel}:  ${booking!.serviceType}',
      '${l10n.bookingsPriceLabel}:  ${l10n.currencyFormat(booking!.price.toString())}',
      '${l10n.status}:  ${booking!.statusText}',
    ];

    final appointmentLines = [
      '${l10n.bookingsDateTimeLabel}: ${booking!.scheduledAt}',
      '${l10n.bookingDetailsVehicleLabel}: ${booking!.vehicle.brand} ${booking!.vehicle.model}',
      '${l10n.plate}: ${booking!.vehicle.plateNumber}',
    ];

    return BlocProvider(
      create: (_) => getIt<CustomerBookingsCubit>(),
      child: BlocListener<CustomerBookingsCubit, CustomerBookingsState>(
        listener: (context, state) {
          if (state is CustomerBookingActionSuccess) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.green,
                ),
              );
            context.safePopOrGo(Routes.bookings, result: true);
          } else if (state is CustomerBookingActionError) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.red,
                ),
              );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          appBar: CustomAppBar(
            title: l10n.bookingDetailsPageTitle,
            showBackButton: true,
            onBackTapped: () => context.safePopOrGo(Routes.bookings),
          ),
          body: ImageBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VehicleImageBox(imageUrl: vehicleImageUrl),
                    SizedBox(height: 14.h),
                    AppText.sectionTitle(
                      context,
                      l10n.bookingDetailsServiceSectionTitle,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: 6.h),
                    DetailsCard(lines: serviceLines),
                    SizedBox(height: 12.h),
                    AppText.sectionTitle(
                      context,
                      l10n.bookingDetailsAppointmentSectionTitle,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: 6.h),
                    DetailsCard(lines: appointmentLines),
                    SizedBox(height: 25.h),
                    ActionButtons(booking: booking!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
