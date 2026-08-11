import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

/// Only emitted for the initial fetch of a filter — never for accept/
/// reject/start/complete, so an in-flight action never blanks the list.
class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingsEntity> items;
  final String status;

  /// Ids of bookings with an accept/reject/start/complete request still in
  /// flight — usually empty here, but a second booking's action can still
  /// be running when this list state is re-emitted (e.g. after the first
  /// action's own re-fetch completes).
  final Set<int> busyBookingIds;

  BookingsLoaded(
    this.items, {
    required this.status,
    this.busyBookingIds = const {},
  });
}

class BookingsError extends BookingsState {
  final String message;
  BookingsError(this.message);
}

// ── Action States ──
// These carry the same items/status BookingsLoaded had — an action in
// flight (or its result) must never blank the list the user is looking at.
class BookingActionLoading extends BookingsState {
  /// The booking that just triggered this specific transition.
  final int bookingId;
  final List<BookingsEntity> currentItems;
  final String currentStatus;

  /// Every booking id currently mid-action — not just [bookingId] — so two
  /// different bookings can be in flight at once without one clobbering
  /// the other's busy indicator.
  final Set<int> busyBookingIds;

  BookingActionLoading(
    this.bookingId, {
    required this.currentItems,
    required this.currentStatus,
    this.busyBookingIds = const {},
  });
}

class BookingActionSuccessMessage extends BookingsState {
  BookingActionSuccessMessage(
    this.message, {
    required this.currentItems,
    required this.currentStatus,
    this.busyBookingIds = const {},
  });
  final String message;
  final List<BookingsEntity> currentItems;
  final String currentStatus;
  final Set<int> busyBookingIds;
}

class BookingActionError extends BookingsState {
  final String message;
  final List<BookingsEntity> currentItems;
  final String currentStatus;
  final Set<int> busyBookingIds;
  BookingActionError(
    this.message, {
    required this.currentItems,
    required this.currentStatus,
    this.busyBookingIds = const {},
  });
}
