// حالات متابعة توصيل طلب قطع الغيار للعميل.
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/entities/spare_order_track_entity.dart';
import 'package:latlong2/latlong.dart';

abstract class CustomerDeliveryTrackingState {}

class CustomerDeliveryTrackingLoading extends CustomerDeliveryTrackingState {}

class CustomerDeliveryTrackingWaiting extends CustomerDeliveryTrackingState {}

class CustomerDeliveryTrackingLoaded extends CustomerDeliveryTrackingState {
  final SpareOrderTrackEntity data;
  final LatLng? deliveryLocation;
  CustomerDeliveryTrackingLoaded(this.data, {this.deliveryLocation});
}

class CustomerDeliveryTrackingEnded extends CustomerDeliveryTrackingState {
  final String status;
  CustomerDeliveryTrackingEnded(this.status);
}

class CustomerDeliveryTrackingError extends CustomerDeliveryTrackingState {
  final String message;
  CustomerDeliveryTrackingError(this.message);
}
