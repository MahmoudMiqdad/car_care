import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_info_column.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_quick_actions_column.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_status_chips_row.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_view_details_button.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

typedef WasherBookingActionVisibility = ({
  bool showAcceptReject,
  bool showStartComplete,
  bool showCompleteOnly,
});

WasherBookingActionVisibility washerBookingActionVisibilityFor(String status) {
  return (
    showAcceptReject: status == 'pending',
    showStartComplete: status == 'accepted',
    showCompleteOnly: status == 'in_progress',
  );
}

class WasherBookingCard extends StatefulWidget {
  const WasherBookingCard({
    super.key,
    required this.booking,
    this.busy = false,
  });

  final BookingsEntity booking;

  final bool busy;

  @override
  State<WasherBookingCard> createState() => _WasherBookingCardState();
}

class _WasherBookingCardState extends State<WasherBookingCard> {
  bool _rejectMode = false;
  final TextEditingController _rejectController = TextEditingController();

  @override
  void dispose() {
    _rejectController.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
 final string = context.l10n;
    final visibility = washerBookingActionVisibilityFor(booking.status);
    final showDefaultActions = visibility.showAcceptReject;
    final showAfterAcceptActions = visibility.showStartComplete;
    final showInProgressActions = visibility.showCompleteOnly;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
      child: Column(
        children: [
          WasherBookingStatusChipsRow(
            status: booking.status,
            label: booking.statusText,
          ),
          SizedBox(height: 10.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: WasherBookingInfoColumn(booking: booking)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Container(
                  width: 1,
                  height: 180.h,
                  color: AppColors.black.withValues(alpha: 0.35),
                ),
              ),

              WasherBookingQuickActionsColumn(
                showAcceptReject: showDefaultActions,
                showStartComplete: showAfterAcceptActions,
                showCompleteOnly: showInProgressActions,
                busy: widget.busy,

                rejectMode: _rejectMode,
                rejectController: _rejectController,

                onAccept: () {
                  setState(() => _rejectMode = false);
                  context.read<BookingsCubit>().acceptBooking(booking.id);
                },

                onRejectTap: () {
                  setState(() => _rejectMode = true);
                },

                onRejectSubmit: () {
                  final reason = _rejectController.text.trim();
                  if (reason.isEmpty) {
                    _snack(string.pleaseEnterRejectionReason);
                    return;
                  }
                  context.read<BookingsCubit>().rejectBooking(
                    booking.id,
                    reason,
                  );
                  setState(() => _rejectMode = false);
                  _rejectController.clear();
                },

                onStartExecution: () =>
                    context.read<BookingsCubit>().startExecution(booking.id),
                onComplete: () =>
                    context.read<BookingsCubit>().completeBooking(booking.id),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          WasherBookingViewDetailsButton(
            onPressed: () async {
              final cubit = context.read<BookingsCubit>();
              final changed = await context.push<bool>(
                Routes.washerBookingsDetails,
                extra: booking,
              );
              if (changed == true) {
                cubit.fetchBookings(status: cubit.currentStatus);
              }
            },
          ),
        ],
      ),
    );
  }
}
