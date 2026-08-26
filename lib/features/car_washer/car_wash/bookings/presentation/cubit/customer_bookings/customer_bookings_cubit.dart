import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/repositories/i_customer_bookings_repository.dart';
import 'customer_bookings_state.dart';

class CustomerBookingsCubit extends Cubit<CustomerBookingsState> {
  CustomerBookingsCubit(this._repo) : super(CustomerBookingsInitial());

  final ICustomerBookingsRepository _repo;

  String? _currentStatus;
  List<BookingsEntity> _currentItems = [];

  Future<void> fetchBookings({String? status}) async {
    _currentStatus = status;

    emit(CustomerBookingsLoading());

    final res = await _repo.getBookings(status: _currentStatus);

    res.fold((f) => emit(CustomerBookingsError(f.message)), (items) {
      _currentItems = items;
      emit(CustomerBookingsLoaded(items, status: _currentStatus));
    });
  }

  Future<void> cancelBooking(int bookingId, String reason) async {
    emit(
      CustomerBookingActionLoading(
        bookingId,
        currentItems: _currentItems,
        currentStatus: _currentStatus,
      ),
    );

    final res = await _repo.cancelBooking(bookingId, reason);

    res.fold(
      (f) => emit(
        CustomerBookingActionError(
          f.message,
          currentItems: _currentItems,
          currentStatus: _currentStatus,
        ),
      ),
      (data) {
        final msg = (data['message'] ?? '').toString();
        emit(
          CustomerBookingActionSuccess(
            msg,
            currentItems: _currentItems,
            currentStatus: _currentStatus,
          ),
        );
      },
    );
  }
}
