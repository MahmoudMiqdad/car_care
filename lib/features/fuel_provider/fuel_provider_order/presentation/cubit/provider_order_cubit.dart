import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelProviderOrderCubit extends Cubit<FuelProviderOrderState> {
  final IFuelProviderOrderRepository _repo;

  FuelProviderOrderCubit(this._repo) : super(FuelProviderOrderInitial());

  /// Last successfully loaded order details, kept so a failed action
  /// (accept/start/complete/cancel) can restore them instead of leaving
  /// the details page blank.
  FuelOrderEntity? _lastOrder;

  Future<void> getOrder(int id) async {
    emit(FuelProviderOrderLoading());

    final res = await _repo.getOrder(id);

    res.fold(
      (l) => emit(FuelProviderOrderError(l.displayMessage)),
      (r) {
        _lastOrder = r;
        emit(FuelProviderOrderDetailsLoaded(r));
      },
    );
  }

  Future<void> acceptOrder(
    int id, {
    int? estimatedArrivalMinutes,
    String? notes,
  }) async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.acceptOrder(
      id,
      estimatedArrivalMinutes: estimatedArrivalMinutes,
      notes: notes,
    );
    res.fold(
      (l) => emit(FuelProviderOrderActionError(l.displayMessage, _lastOrder)),
      (r) => emit(FuelProviderOrderAccepted(r)),
    );
  }

  Future<void> startOrder(int id) async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.startOrder(id);
    res.fold(
      (l) => emit(FuelProviderOrderActionError(l.displayMessage, _lastOrder)),
      (r) => emit(FuelProviderOrderStarted(r)),
    );
  }

  Future<void> completeOrder(int id) async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.completeOrder(id);
    res.fold(
      (l) => emit(FuelProviderOrderActionError(l.displayMessage, _lastOrder)),
      (r) => emit(FuelProviderOrderCompleted(r)),
    );
  }

  Future<void> cancelOrder(int id, String reason) async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.cancelOrder(id, reason);
    res.fold(
      (l) => emit(FuelProviderOrderActionError(l.displayMessage, _lastOrder)),
      (r) => emit(FuelProviderOrderCancelled(r)),
    );
  }

  Future<void> getMyOrders() async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.getMyOrders();
    res.fold(
      (l) => emit(FuelProviderOrderError(l.displayMessage)),
      (r) => emit(FuelProviderOrdersListLoaded(r)),
    );
  }

  Future<void> getAvailableOrders() async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.getavailableOrders();
    res.fold(
      (l) => emit(FuelProviderOrderError(l.displayMessage)),
      (r) => emit(FuelProviderOrdersListLoaded(r)),
    );
  }
}
