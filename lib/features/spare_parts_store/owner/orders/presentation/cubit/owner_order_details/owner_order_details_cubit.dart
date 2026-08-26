import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/domain/repositories/i_owner_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerOrderDetailsCubit extends Cubit<OwnerOrderDetailsState> {
  OwnerOrderDetailsCubit(this._repository) : super(OwnerOrderDetailsInitial());

  final IOwnerOrdersRepository _repository;

  Future<void> fetchOrderDetails(int orderId) async {
    emit(OwnerOrderDetailsLoading());
    final result = await _repository.getOrderDetails(orderId);
    result.fold(
      (failure) => emit(OwnerOrderDetailsError(failure.message)),
      (order) => emit(OwnerOrderDetailsLoaded(order)),
    );
  }

  Future<void> acceptOrder(int orderId) => _runAction(
    orderId,
    OwnerOrderActionType.accept,
    () => _repository.acceptOrder(orderId),
  );

  Future<void> rejectOrder(int orderId, String reason) => _runAction(
    orderId,
    OwnerOrderActionType.reject,
    () => _repository.rejectOrder(orderId, reason),
  );

  Future<void> startProcessing(int orderId) => _runAction(
    orderId,
    OwnerOrderActionType.startProcessing,
    () => _repository.updateStatus(orderId, 'processing', 'جاري تجهيز الطلبية'),
  );

  Future<void> startDelivery(int orderId) => _runAction(
    orderId,
    OwnerOrderActionType.startDelivery,
    () =>
        _repository.updateStatus(orderId, 'out_for_delivery', 'تم بدء التوصيل'),
  );

  Future<void> confirmDelivered(int orderId) => _runAction(
    orderId,
    OwnerOrderActionType.confirmDelivered,
    () => _repository.updateStatus(orderId, 'delivered', 'تم التوصيل بنجاح'),
  );

  Future<void> _runAction(
    int orderId,
    OwnerOrderActionType actionType,
    Future<Either<Failure, OrderEntity>> Function() call,
  ) async {
    final current = state;
    if (current is! OwnerOrderDetailsLoaded || current.isActing) return;

    emit(OwnerOrderDetailsLoaded(current.order, activeAction: actionType));

    final result = await call();
    result.fold(
      (failure) => emit(
        OwnerOrderDetailsLoaded(current.order, actionError: failure.message),
      ),
      (updatedOrder) => emit(
        OwnerOrderDetailsLoaded(updatedOrder, completedAction: actionType),
      ),
    );
  }

  void clearActionError() {
    final current = state;
    if (current is OwnerOrderDetailsLoaded && current.actionError != null) {
      emit(OwnerOrderDetailsLoaded(current.order));
    }
  }

  void clearSuccessMessage() {
    final current = state;
    if (current is OwnerOrderDetailsLoaded && current.completedAction != null) {
      emit(OwnerOrderDetailsLoaded(current.order));
    }
  }
}
