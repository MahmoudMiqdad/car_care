import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_details/washer_bookings_details_section.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_card.dart'
    show washerBookingActionVisibilityFor;
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_quick_actions_column.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_status_chips_row.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherBookingsDetailsBody extends StatefulWidget {
  const WasherBookingsDetailsBody({
    super.key,
    required this.bookingId,
    required this.onChanged,
  });

  final int bookingId;

  final VoidCallback onChanged;

  @override
  State<WasherBookingsDetailsBody> createState() =>
      _WasherBookingsDetailsBodyState();
}

class _WasherBookingsDetailsBodyState extends State<WasherBookingsDetailsBody> {
  bool _rejectMode = false;
  final TextEditingController _rejectController = TextEditingController();
  String? _lastSeenStatus;

  @override
  void dispose() {
    _rejectController.dispose();
    super.dispose();
  }

  BookingsEntity? _currentBooking(BookingsState state) {
    final pool = _itemsOf(state);
    if (pool == null) return null;
    for (final b in pool) {
      if (b.id == widget.bookingId) return b;
    }
    return null;
  }

  Iterable<BookingsEntity>? _itemsOf(BookingsState state) {
    if (state is BookingsLoaded) return state.items;
    if (state is BookingActionLoading) return state.currentItems;
    if (state is BookingActionSuccessMessage) return state.currentItems;
    if (state is BookingActionError) return state.currentItems;
    return null;
  }

  Set<int> _busyIdsOf(BookingsState state) {
    if (state is BookingsLoaded) return state.busyBookingIds;
    if (state is BookingActionLoading) return state.busyBookingIds;
    if (state is BookingActionSuccessMessage) return state.busyBookingIds;
    if (state is BookingActionError) return state.busyBookingIds;
    return const {};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<BookingsCubit, BookingsState>(
      listener: (context, state) {
        final booking = _currentBooking(state);
        if (booking != null) {
          if (_lastSeenStatus != null && _lastSeenStatus != booking.status) {
            widget.onChanged();
          }
          _lastSeenStatus = booking.status;
        }
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
        final booking = _currentBooking(state);
        if (booking == null) return const SizedBox.shrink();
        _lastSeenStatus ??= booking.status;

        final busy = _busyIdsOf(state).contains(booking.id);

        final ownerName = booking.vehicle.ownerName ?? '---';
        final vehicleName = '${booking.vehicle.brand} ${booking.vehicle.model}'
            .trim();
        final plate = booking.vehicle.plateNumber;
        final priceText = booking.price ?? '0';
        final vehicleImageUrl = resolveMediaUrl(
          vehicleImageRawValue(
            booking.vehicle.image,
            booking.vehicle.imagePath,
          ),
        );

        final serviceLines = <String>[
          '${l10n.washerBookingCustomerNameLabel} $ownerName',
          '${l10n.bookingsServiceLabel}: ${booking.serviceType}',
          '${l10n.bookingsPriceLabel}: \$$priceText',
          '${l10n.bookingsDateTimeLabel}: ${booking.scheduledAt}',
          '${l10n.bookingDetailsVehicleLabel}: $vehicleName',
          '${l10n.plate}: $plate',
        ];

        final userNotesLines = <String>[
          booking.notes.isNotEmpty ? booking.notes : '---',
        ];

        final visibility = washerBookingActionVisibilityFor(booking.status);
        final showAfterAcceptActions = visibility.showStartComplete;
        final showInProgressActions = visibility.showCompleteOnly;

        return Column(
          children: [
            Expanded(
              child: SafeArea(
                top: false,
                bottom: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VehicleImageBox(imageUrl: vehicleImageUrl),
                      SizedBox(height: 10.h),
                      Center(
                        child: WasherBookingStatusChipsRow(
                          status: booking.status,
                          label:
                              carwashBookingFilterLabels(
                                l10n,
                              )[booking.status] ??
                              booking.statusText,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      WasherBookingsDetailsSection(
                        title: l10n.bookingDetailsServiceSectionTitle,
                        lines: serviceLines,
                      ),
                      SizedBox(height: 12.h),
                      WasherBookingsDetailsSection(
                        title: l10n.bookingDetailsUserNotesSectionTitle,
                        lines: userNotesLines,
                        textAlign: TextAlign.center,
                        contentFontWeight: FontWeight.w800,
                      ),
                      if (showAfterAcceptActions ||
                          showInProgressActions) ...[
                        SizedBox(height: 16.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: WasherBookingQuickActionsColumn(
                            showAcceptReject: false,
                            showStartComplete: showAfterAcceptActions,
                            showCompleteOnly: showInProgressActions,
                            busy: busy,
                            rejectMode: _rejectMode,
                            rejectController: _rejectController,
                            onAccept: () {
                              setState(() => _rejectMode = false);
                              context.read<BookingsCubit>().acceptBooking(
                                booking.id,
                              );
                            },
                            onRejectTap: () {
                              setState(() => _rejectMode = true);
                            },
                            onRejectSubmit: () {
                              final reason = _rejectController.text.trim();
                              if (reason.isEmpty) {
                                AppSnackBar.error(
                                  context,
                                  l10n.pleaseEnterRejectionReason,
                                );
                                return;
                              }
                              context.read<BookingsCubit>().rejectBooking(
                                booking.id,
                                reason,
                              );
                              setState(() => _rejectMode = false);
                              _rejectController.clear();
                            },
                            onStartExecution: () => context
                                .read<BookingsCubit>()
                                .startExecution(booking.id),
                            onComplete: () => context
                                .read<BookingsCubit>()
                                .completeBooking(booking.id),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
