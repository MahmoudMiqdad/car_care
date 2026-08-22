import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(CartInitial());

  final ICartRepository _repository;

  Future<void> fetchCart() async {
    emit(CartLoading());

    final result = await _repository.getCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) {
        if (cart.items.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(CartLoaded(cart));
        }
      },
    );
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final current = state;
    if (current is! CartLoaded) return;

    emit(
      CartLoaded(
        current.cart,
        quantityUpdatingItemIds: {...current.quantityUpdatingItemIds, cartItemId},
        deletingItemIds: current.deletingItemIds,
      ),
    );

    final result = await _repository.updateCartItem(
      cartItemId: cartItemId,
      quantity: quantity,
    );

    result.fold(
      (failure) => emit(
        CartLoaded(
          current.cart,
          deletingItemIds: current.deletingItemIds,
          actionError: failure.message,
        ),
      ),
      (_) => _refreshSilently(),
    );
  }

  Future<void> removeItem(int cartItemId) async {
    final current = state;
    if (current is! CartLoaded) return;

    emit(
      CartLoaded(
        current.cart,
        quantityUpdatingItemIds: current.quantityUpdatingItemIds,
        deletingItemIds: {...current.deletingItemIds, cartItemId},
      ),
    );

    final result = await _repository.deleteCartItem(cartItemId);

    result.fold(
      (failure) => emit(
        CartLoaded(
          current.cart,
          quantityUpdatingItemIds: current.quantityUpdatingItemIds,
          actionError: failure.message,
        ),
      ),
      (_) => _refreshSilently(),
    );
  }

  Future<void> _refreshSilently() async {
    final result = await _repository.getCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) {
        if (cart.items.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(CartLoaded(cart));
        }
      },
    );
  }

  void clearActionError() {
    final current = state;
    if (current is CartLoaded && current.actionError != null) {
      emit(
        CartLoaded(
          current.cart,
          quantityUpdatingItemIds: current.quantityUpdatingItemIds,
          deletingItemIds: current.deletingItemIds,
        ),
      );
    }
  }
}
