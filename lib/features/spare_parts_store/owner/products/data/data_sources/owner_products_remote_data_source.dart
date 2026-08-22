
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/spare_parts_store/customer/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

class OwnerProductsRemoteDataSource {
  const OwnerProductsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.ownerShopProducts,
    );
    return ProductModel.listFromResponse(response);
  }

  Future<ProductModel> createProduct(FormData formData) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.ownerShopProducts,
      data: formData,
    );
    return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ProductModel> updateProduct(
    int productId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.put(
      endPoint: ApiEndpoints.ownerShopProductById(productId),
      data: data,
    );
    return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<String> deleteProduct(int productId) async {
    final response = await _apiService.delete(
      endPoint: ApiEndpoints.ownerShopProductById(productId),
    );
    if (response['success'] == false) {
      throw ServerExpcptions(
        error: Failure(
          message: (response['message'] ?? 'حدث خطأ أثناء حذف المنتج')
              .toString(),
        ),
      );
    }
    return (response['message'] ?? 'تم حذف المنتج بنجاح').toString();
  }
}
