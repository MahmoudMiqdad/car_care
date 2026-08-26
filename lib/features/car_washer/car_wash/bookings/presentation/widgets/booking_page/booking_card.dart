import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'booking_details_content.dart';
import 'booking_status_chips.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking});

  final BookingsEntity booking;

  Future<void> _openDetails(BuildContext context) async {
    final changed = await context.push(Routes.bookingDetails, extra: booking);
    if (changed == true && context.mounted) {
      context.read<CustomerBookingsCubit>().fetchBookings(status: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => _openDetails(context),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border(context)),
          ),
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingStatusChips(
                status: booking.status,
                label:
                    carwashBookingFilterLabels(l10n)[booking.status] ??
                    booking.statusText,
              ),
              SizedBox(height: 8.h),
              BookingDetailsContent(
                booking: booking,
                onShowDetails: () => _openDetails(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
