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

class FuelProviderOrderStarted extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderStarted(this.order);
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

/// Emitted when accept/start/complete/cancel fails after details were
/// already loaded, so the UI can keep showing [order] (the last loaded
/// details) instead of going blank while still reporting [message] via a
/// snackbar.
class FuelProviderOrderActionError extends FuelProviderOrderState {
  final String message;
  final FuelOrderEntity? order;
  FuelProviderOrderActionError(this.message, this.order);
}

class FuelProviderOrderDetailsLoaded extends FuelProviderOrderState {
  final FuelOrderEntity order;
  FuelProviderOrderDetailsLoaded(this.order);
}
