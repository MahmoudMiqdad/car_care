import 'package:car_care/core/config/env.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/network/interceptors/auth_interceptor.dart';
import 'package:car_care/core/network/interceptors/dio_interceptors.dart';
import 'package:car_care/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class ApiClient {
  static ApiClient? _instance;

  final Dio dio;

  factory ApiClient({
    required SecureStorage secureStorage,
  }) {
    return _instance ??= ApiClient._internal(secureStorage: secureStorage);
  }

  ApiClient._internal({
    required SecureStorage secureStorage,
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    dio.interceptors.addAll([

      AuthInterceptor(
        secureStorage: secureStorage,
        apiClient: this,

      ),
      ErrorFailureInterceptor(),
      if (kDebugMode) LoggingInterceptor.i,
    ]);
  }
}