// تنفيذ مستودع منتجات متجر المالك.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/products/data/data_sources/owner_products_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/products/domain/repositories/i_owner_products_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class OwnerProductsRepositoryImpl implements IOwnerProductsRepository {
  const OwnerProductsRepositoryImpl(this._dataSource);

  final OwnerProductsRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      return Right(await _dataSource.getProducts());
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب المنتجات'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
    FormData formData,
  ) async {
    try {
      return Right(await _dataSource.createProduct(formData));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء إضافة المنتج'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
    int productId, {
    double? price,
    int? stockQuantity,
  }) async {
    try {
      final data = <String, dynamic>{
        'price': ?price,
        'stock_quantity': ?stockQuantity,
      };
      return Right(await _dataSource.updateProduct(productId, data));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء تعديل المنتج'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(int productId) async {
    try {
      return Right(await _dataSource.deleteProduct(productId));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء حذف المنتج'));
    }
  }
}
