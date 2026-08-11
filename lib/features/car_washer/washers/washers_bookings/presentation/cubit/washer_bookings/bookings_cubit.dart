import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/data/model/booking_model.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/domain/repositories/i_bookings_repository.dart';
import 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit(this._repository) : super(BookingsInitial());

  final IBookingsRepository _repository;

  String? _currentStatus;
  List<BookingsEntity> _currentItems = [];

  /// Every booking id with an accept/reject/start/complete request
  /// currently in flight. A set (not a single nullable id) so an action on
  /// one booking never clobbers the busy tracking of another booking whose
  /// own request is still running.
  final Set<int> _busyBookingIds = {};

  /// The status filter currently applied to the list — lets a caller that
  /// isn't this cubit (e.g. the details page, after an action) re-fetch
  /// with the same filter instead of silently resetting it to "all".
  String? get currentStatus => _currentStatus;

  Future<void> fetchBookings({String? status}) async {
    _currentStatus = status;

    emit(BookingsLoading());

    final result = await _repository.getBookings(status: _currentStatus);

    result.fold((failure) => emit(BookingsError(failure.displayMessage)), (
      items,
    ) {
      _currentItems = items;
      emit(
        BookingsLoaded(
          items,
          status: _currentStatus ?? 'all',
          busyBookingIds: Set.unmodifiable(_busyBookingIds),
        ),
      );
    });
  }

  /// Used by the booking-details page, which has no list of its own to
  /// fetch: seeds this cubit with just the one booking passed in via
  /// navigation `extra`, so the existing accept/reject/start/complete
  /// logic below (including in-place status updates) works there too,
  /// without a `GET` for a single booking (which the API doesn't expose).
  void seedSingle(BookingsEntity booking) {
    _currentItems = [booking];
    _currentStatus = null;
    _busyBookingIds.clear();
    emit(BookingsLoaded(_currentItems, status: 'all'));
  }

  /// Parses the updated booking out of the endpoint's `data` field.
  /// Returns null — never throws — whenever `data` is missing, not a map,
  /// or fails to parse into a full `BookingModel` (e.g. a partial
  /// response missing `vehicle`), so a malformed response can never crash
  /// the cubit; the caller falls back to a single re-fetch instead.
  BookingsEntity? _bookingFromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    try {
      return BookingModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Applies a single accept/reject/start/complete action without ever
  /// emitting a state that drops the currently-visible list:
  /// - a booking already being acted on refuses a second call, but a
  ///   different booking's own action is never blocked by it,
  /// - the loading/error/success states all carry the same items+status
  ///   plus the full set of currently-busy booking ids,
  /// - on success, the item is updated in place from the response when it
  ///   includes the updated booking (dropped from the list instead if its
  ///   new status no longer matches the active filter); otherwise exactly
  ///   one re-fetch (with the active filter) is awaited to learn the
  ///   confirmed status — never both, and never left un-awaited.
  Future<void> _runAction({
    required int bookingId,
    required Future<Either<Failure, Map<String, dynamic>>> Function() call,
  }) async {
    if (_busyBookingIds.contains(bookingId)) return;

    final statusLabel = _currentStatus ?? 'all';
    _busyBookingIds.add(bookingId);
    emit(
      BookingActionLoading(
        bookingId,
        currentItems: _currentItems,
        currentStatus: statusLabel,
        busyBookingIds: Set.unmodifiable(_busyBookingIds),
      ),
    );

    final result = await call();

    await result.fold(
      (failure) async {
        _busyBookingIds.remove(bookingId);
        emit(
          BookingActionError(
            failure.displayMessage,
            currentItems: _currentItems,
            currentStatus: statusLabel,
            busyBookingIds: Set.unmodifiable(_busyBookingIds),
          ),
        );
      },
      (res) async {
        emit(
          BookingActionSuccessMessage(
            (res['message'] ?? 'تم تنفيذ الإجراء بنجاح').toString(),
            currentItems: _currentItems,
            currentStatus: statusLabel,
            busyBookingIds: Set.unmodifiable(_busyBookingIds),
          ),
        );

        final updated = _bookingFromResponse(res);
        if (updated != null) {
          final index = _currentItems.indexWhere((b) => b.id == bookingId);
          final matchesFilter =
              _currentStatus == null || updated.status == _currentStatus;
          final next = List<BookingsEntity>.from(_currentItems);
          if (index != -1) {
            if (matchesFilter) {
              next[index] = updated;
            } else {
              next.removeAt(index);
            }
          } else if (matchesFilter) {
            next.add(updated);
          }
          _currentItems = next;
          _busyBookingIds.remove(bookingId);
          emit(
            BookingsLoaded(
              _currentItems,
              status: statusLabel,
              busyBookingIds: Set.unmodifiable(_busyBookingIds),
            ),
          );
        } else {
          // Endpoint only returned a message (or an unparseable/partial
          // `data`) — one awaited re-fetch from the existing source to
          // learn the confirmed status; never a second request beyond it.
          await fetchBookings(status: _currentStatus);
          _busyBookingIds.remove(bookingId);
          final latest = state;
          if (latest is BookingsLoaded) {
            emit(
              BookingsLoaded(
                latest.items,
                status: latest.status,
                busyBookingIds: Set.unmodifiable(_busyBookingIds),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> acceptBooking(int bookingId) => _runAction(
    bookingId: bookingId,
    call: () => _repository.acceptBooking(bookingId),
  );

  Future<void> rejectBooking(int bookingId, String reason) => _runAction(
    bookingId: bookingId,
    call: () => _repository.rejectBooking(bookingId, reason),
  );

  Future<void> startExecution(int bookingId) => _runAction(
    bookingId: bookingId,
    call: () => _repository.updateBookingStatus(bookingId, 'in_progress'),
  );

  Future<void> completeBooking(int bookingId) => _runAction(
    bookingId: bookingId,
    call: () => _repository.updateBookingStatus(bookingId, 'completed'),
  );
}
