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

  final Set<int> _busyBookingIds = {};

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

  void seedSingle(BookingsEntity booking) {
    _currentItems = [booking];
    _currentStatus = null;
    _busyBookingIds.clear();
    emit(BookingsLoaded(_currentItems, status: 'all'));
  }

  BookingsEntity? _bookingFromResponse(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    try {
      return BookingModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

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
