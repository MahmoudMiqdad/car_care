import 'dart:io';

import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService(this._apiClient);

  final ApiClient _apiClient;

  Dio get _dio => _apiClient.dio;

  /// GET request
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _performRequest(
      () => _dio.get(
        endPoint,
        queryParameters: queryParameters,
      ),
    );
  }

  /// POST request
  Future<Map<String, dynamic>> post({
    required String endPoint,
    dynamic data,
  }) async {
    return _performRequest(
      () => _dio.post(endPoint, data: data),
    );
  }

  /// PUT request
  Future<Map<String, dynamic>> put({
    required String endPoint,
    required String id,
    dynamic data,
  }) async {
    return _performRequest(
      () => _dio.put('$endPoint/$id', data: data),
    );
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete({
    required String endPoint,
    required String id,
  }) async {
    return _performRequest(
      () => _dio.delete('$endPoint/$id'),
    );
  }

  /// Download file
  Future<File> downloadFile({
    required String endPoint,
    required String filePath,
    void Function(int, int)? onProgress,
  }) async {
    try {
      await _dio.download(
        endPoint,
        filePath,
        onReceiveProgress: onProgress,
      );
      return File(filePath);
    } on DioException catch (e) {
      handelDioExcptions(e);
      rethrow; // احتياط
    } catch (_) {
      throw ServerExpcptions(
        error: const Failure(message: "حدث خطأ غير متوقع"),
      );
    }
  }

  /// perform request
  Future<Map<String, dynamic>> _performRequest(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      return {'data': response.data};
    } on DioException catch (e) {
      handelDioExcptions(e);
      rethrow; // لن يصل هنا لأن handelDioExcptions ترمي Exception
    } catch (_) {
      throw ServerExpcptions(
        error: const Failure(message: "حدث خطأ غير متوقع"),
      );
    }
  }

  /// absolute url
  Future<Response<dynamic>> getAbsoluteUrl(String url) async {
    final dio = Dio(
      BaseOptions(
        followRedirects: true,
        validateStatus: (_) => true,
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    return dio.get(url);
  }
}