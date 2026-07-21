// كيوبت تتبع توصيل طلب قطع الغيار — يستطلع API كل ١٠ ثوان مع حماية من التداخل.
import 'dart:async';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/repositories/i_spare_order_track_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class CustomerDeliveryTrackingCubit extends Cubit<CustomerDeliveryTrackingState> {
  final ISpareOrderTrackRepository _repo;
  Timer? _timer;
  bool _isFetching = false;
  bool _hasData = false;

  CustomerDeliveryTrackingCubit(this._repo)
      : super(CustomerDeliveryTrackingLoading());

  Future<void> loadTracking(int orderId) async {
    await _fetch(orderId);
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetch(orderId),
    );
  }

  Future<void> _fetch(int orderId) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      final res = await _repo.trackOrder(orderId);
      res.fold(
        (failure) {
          if (!_hasData) emit(CustomerDeliveryTrackingError(failure.message));
        },
        (entity) {
          final status = entity.orderStatus ?? '';
          if (status == 'delivered' || status == 'cancelled') {
            _timer?.cancel();
            emit(CustomerDeliveryTrackingEnded(status));
            return;
          }
          final loc = entity.lastLocation;
          final deliveryLocation =
              (loc?.latitude != null && loc?.longitude != null)
                  ? LatLng(loc!.latitude!, loc.longitude!)
                  : null;
          if (deliveryLocation == null && entity.trackingPoints.isEmpty) {
            if (!_hasData) emit(CustomerDeliveryTrackingWaiting());
          } else {
            _hasData = true;
            emit(CustomerDeliveryTrackingLoaded(entity,
                deliveryLocation: deliveryLocation));
          }
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
