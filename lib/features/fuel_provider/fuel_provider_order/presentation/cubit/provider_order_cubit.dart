import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelProviderOrderCubit extends Cubit<FuelProviderOrderState> {
  final IFuelProviderOrderRepository _repo;

  FuelProviderOrderCubit(this._repo) : super(FuelProviderOrderInitial());

Future<void> getOrder(int id) async {
  emit(FuelProviderOrderLoading());

  final res = await _repo.getOrder(id);

  res.fold(
  
 (l) => emit(FuelProviderOrderError(l.message)),
(r) => emit(FuelProviderOrderDetailsLoaded(r))
    
  );
}
  Future<void> acceptOrder(int id) async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.acceptOrder(id);
    res.fold(
      (l) => emit(FuelProviderOrderError(l.message)),
      (r) => emit(FuelProviderOrderAccepted(r)),
    );
  }

  Future<void> completeOrder(int id) async {
    final res = await _repo.completeOrder(id);
    res.fold(
      (l) => emit(FuelProviderOrderError(l.message)),
      (r) => emit(FuelProviderOrderCompleted(r)),
    );
  }

  Future<void> cancelOrder(int id, String reason) async {
    final res = await _repo.cancelOrder(id, reason);
    res.fold(
      (l) => emit(FuelProviderOrderError(l.message)),
      (r) => emit(FuelProviderOrderCancelled(r)),
    );
  }

  Future<void> getMyOrders() async {
    emit(FuelProviderOrderLoading());
    final res = await _repo.getMyOrders();
    res.fold(
      (l) => emit(FuelProviderOrderError(l.message)),
      (r) => emit(FuelProviderOrdersListLoaded(r)),
    );
  }
 
Future<void> getAvailableOrders() async {
  emit(FuelProviderOrderLoading());
  final res = await _repo.getavailableOrders();
  res.fold(
    (l) => emit(FuelProviderOrderError(l.message)),
    (r) => emit(FuelProviderOrdersListLoaded(r)),
  );
}
}