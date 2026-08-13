import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_details/washer_bookings_details_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WasherBookingsDetails extends StatefulWidget {
  const WasherBookingsDetails({super.key, required this.booking});
  final BookingsEntity booking;

  @override
  State<WasherBookingsDetails> createState() => _WasherBookingsDetailsState();
}

class _WasherBookingsDetailsState extends State<WasherBookingsDetails> {
  bool _changed = false;

  void _popBack() {
    if (context.canPop()) {
      context.pop(_changed);
    } else {
      context.go(Routes.washerBookings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>()..seedSingle(widget.booking),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            title: context.l10n.bookingDetailsPageTitle,
            showBackButton: true,
            onBackTapped: _popBack,
          ),
          body: ImageBackground(
            child: WasherBookingsDetailsBody(
              bookingId: widget.booking.id,
              onChanged: () => _changed = true,
            ),
          ),
        ),
      ),
    );
  }
}
