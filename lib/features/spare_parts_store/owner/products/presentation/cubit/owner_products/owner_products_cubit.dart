// إدارة حالة قائمة منتجات متجر المالك: جلب / إضافة / حذف / تعديل جزئي.
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/products/domain/repositories/i_owner_products_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerProductsCubit extends Cubit<OwnerProductsState> {
  OwnerProductsCubit(this._repository) : super(OwnerProductsInitial());

  final IOwnerProductsRepository _repository;

  Future<void> createProduct(FormData formData) async {
    final current = state;
    final List<ProductEntity> baseProducts;
    if (current is OwnerProductsLoaded) {
      if (current.isCreating) return;
      baseProducts = current.products;
    } else if (current is OwnerProductsEmpty) {
      baseProducts = const [];
    } else {
      return;
    }

    emit(OwnerProductsLoaded(baseProducts, isCreating: true));

    final result = await _repository.createProduct(formData);

    result.fold(
      (failure) =>
          emit(OwnerProductsLoaded(baseProducts, createError: failure.message)),
      (created) => emit(OwnerProductsLoaded([created, ...baseProducts])),
    );
  }

  void clearCreateError() {
    final current = state;
    if (current is OwnerProductsLoaded && current.createError != null) {
      emit(
        OwnerProductsLoaded(current.products, deletingIds: current.deletingIds),
      );
    }
  }

  Future<void> fetchProducts() async {
    emit(OwnerProductsLoading());
    final result = await _repository.getProducts();
    result.fold(
      (failure) => emit(OwnerProductsError(failure.message)),
      (products) => emit(
        products.isEmpty ? OwnerProductsEmpty() : OwnerProductsLoaded(products),
      ),
    );
  }

  Future<void> updateProduct(
    int productId, {
    double? price,
    int? stockQuantity,
  }) async {
    final current = state;
    if (current is! OwnerProductsLoaded || current.savingId != null) return;

    emit(
      OwnerProductsLoaded(
        current.products,
        deletingIds: current.deletingIds,
        savingId: productId,
      ),
    );

    final result = await _repository.updateProduct(
      productId,
      price: price,
      stockQuantity: stockQuantity,
    );

    result.fold(
      (failure) => emit(
        OwnerProductsLoaded(
          current.products,
          deletingIds: current.deletingIds,
          actionError: failure.message,
        ),
      ),
      (updated) => emit(
        OwnerProductsLoaded([
          for (final p in current.products)
            if (p.id == updated.id) updated else p,
        ], deletingIds: current.deletingIds),
      ),
    );
  }

  Future<void> deleteProduct(int productId) async {
    final current = state;
    if (current is! OwnerProductsLoaded) return;
    if (current.deletingIds.contains(productId)) return;

    emit(
      OwnerProductsLoaded(
        current.products,
        deletingIds: {...current.deletingIds, productId},
      ),
    );

    final result = await _repository.deleteProduct(productId);

    result.fold(
      (failure) => emit(
        OwnerProductsLoaded(
          current.products,
          deletingIds: current.deletingIds
              .where((id) => id != productId)
              .toSet(),
          actionError: failure.message,
        ),
      ),
      (_) {
        final remaining = current.products
            .where((p) => p.id != productId)
            .toList();
        emit(
          remaining.isEmpty
              ? OwnerProductsEmpty()
              : OwnerProductsLoaded(remaining),
        );
      },
    );
  }

  void clearActionError() {
    final current = state;
    if (current is OwnerProductsLoaded && current.actionError != null) {
      emit(
        OwnerProductsLoaded(current.products, deletingIds: current.deletingIds),
      );
    }
  }
}
