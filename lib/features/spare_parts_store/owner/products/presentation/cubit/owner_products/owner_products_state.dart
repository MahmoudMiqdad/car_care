// حالات قائمة منتجات متجر المالك.
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';

abstract class OwnerProductsState {}

class OwnerProductsInitial extends OwnerProductsState {}

class OwnerProductsLoading extends OwnerProductsState {}

class OwnerProductsError extends OwnerProductsState {
  OwnerProductsError(this.message);

  final String message;
}

class OwnerProductsEmpty extends OwnerProductsState {}

class OwnerProductsLoaded extends OwnerProductsState {
  OwnerProductsLoaded(
    this.products, {
    this.deletingIds = const {},
    this.savingId,
    this.actionError,
    this.isCreating = false,
    this.createError,
  });

  final List<ProductEntity> products;
  final Set<int> deletingIds;

  /// ID المنتج الجاري تعديله حاليًا (لمنع الحفظ المكرر).
  final int? savingId;
  final String? actionError;

  /// طلب إنشاء منتج جديد قيد التنفيذ حاليًا (لمنع الضغط المكرر).
  final bool isCreating;
  final String? createError;
}
