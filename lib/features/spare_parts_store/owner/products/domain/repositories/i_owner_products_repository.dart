// واجهة مستودع منتجات متجر المالك.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class IOwnerProductsRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  Future<Either<Failure, ProductEntity>> createProduct(FormData formData);

  Future<Either<Failure, ProductEntity>> updateProduct(
    int productId, {
    double? price,
    int? stockQuantity,
  });

  Future<Either<Failure, String>> deleteProduct(int productId);
}
