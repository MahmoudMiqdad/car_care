import 'dart:io';
import 'package:car_care/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    return _performRequest(() => _dio.get(endPoint));
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    dynamic data,
  }) async {
    return _performRequest(
      () => _dio.post(endPoint, data: data),
    );
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required String id,
    dynamic data,
  }) async {
    return _performRequest(
      () => _dio.put('$endPoint/$id', data: data),
    );
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    required String id,
  }) async {
    return _performRequest(
      () => _dio.delete('$endPoint/$id'),
    );
  }

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
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> _performRequest(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Invalid format',
      );
    }
    return response.data as Map<String, dynamic>;
  }

  Failure _handleError(DioException error) {
    return ServerFailure.fromDioError(error);
  }
}
