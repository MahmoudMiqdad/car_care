import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor._();

  static const LoggingInterceptor i = LoggingInterceptor._();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(' ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        ' ${response.statusCode ?? '-'} '
        '${response.requestOptions.method} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        ' ${err.type} ${err.response?.statusCode ?? '-'} '
        '${err.requestOptions.method} ${err.requestOptions.uri}',
      );
    }
    handler.next(err);
  }
}
