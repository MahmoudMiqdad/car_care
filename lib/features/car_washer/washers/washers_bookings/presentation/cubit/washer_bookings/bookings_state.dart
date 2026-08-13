import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';

abstract class BookingsState {}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingsEntity> items;
  final String status;
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

class BookingActionLoading extends BookingsState {
  final int bookingId;
  final List<BookingsEntity> currentItems;
  final String currentStatus;
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
