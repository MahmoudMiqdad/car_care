import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';

enum OwnerOrderActionType {
  accept,
  reject,
  startProcessing,
  startDelivery,
  confirmDelivered,
}

abstract class OwnerOrderDetailsState {}

class OwnerOrderDetailsInitial extends OwnerOrderDetailsState {}

class OwnerOrderDetailsLoading extends OwnerOrderDetailsState {}

class OwnerOrderDetailsLoaded extends OwnerOrderDetailsState {
  OwnerOrderDetailsLoaded(
    this.order, {
    this.activeAction,
    this.actionError,
    this.completedAction,
  });

  final OrderEntity order;
  final OwnerOrderActionType? activeAction;
  final String? actionError;
  final OwnerOrderActionType? completedAction;

  bool get isActing => activeAction != null;
}

class OwnerOrderDetailsError extends OwnerOrderDetailsState {
  OwnerOrderDetailsError(this.message);

  final String message;
}
