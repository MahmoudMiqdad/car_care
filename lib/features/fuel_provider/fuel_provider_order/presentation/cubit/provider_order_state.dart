// provider_order_state.dart - تأكد عندك هالـ states
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';

abstract class FuelProviderOrderState {}
class FuelProviderOrderInitial extends FuelProviderOrderState {}
class FuelProviderOrderLoading extends FuelProviderOrderState {}
class FuelProviderOrderLoaded extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderLoaded(this.order);
}
class FuelProviderOrdersListLoaded extends FuelProviderOrderState {
  final List<FuelOrderEntity> orders;
  FuelProviderOrdersListLoaded(this.orders);
}
class FuelProviderOrderAccepted extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderAccepted(this.order);
}
class FuelProviderOrderCompleted extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderCompleted(this.order);
}
class FuelProviderOrderCancelled extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderCancelled(this.order);
}
class FuelProviderOrderError extends FuelProviderOrderState {
  final String message;
  FuelProviderOrderError(this.message);
}
class FuelProviderOrderDetailsLoaded extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderDetailsLoaded(this.order);
}