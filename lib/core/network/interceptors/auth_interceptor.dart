import 'dart:async';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorage secureStorage,
    required ApiClient apiClient,
    String refreshPath = ApiEndpoints.refresh,
  }) : _secureStorage = secureStorage,
       _apiClient = apiClient,
       _refreshPath = refreshPath;

  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  final String _refreshPath;

  Dio get _dio => _apiClient.dio;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  void _completeOnce(String? token) {
    final c = _refreshCompleter;
    if (c != null && !c.isCompleted) c.complete(token);
  }

  bool _isAuthEndpoint(String path) {
    const authPaths = <String>[
      ApiEndpoints.login,
      ApiEndpoints.refresh,
      ApiEndpoints.register,
      ApiEndpoints.logout,
    ];

    return authPaths.any((p) => path.contains(p));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (!_isAuthEndpoint(options.path)) {
        final token = await _secureStorage.getToken();

        if (kDebugMode) {
          debugPrint(
            "Auth Token: ${token != null && token.isNotEmpty ? 'Present' : 'Missing'}",
          );
        }

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      handler.next(options);
    } catch (e) {
      if (kDebugMode) debugPrint('Error in onRequest: $e');
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    //logout if the refresh faild
    if (err.requestOptions.path.contains(_refreshPath)) {
      await _secureStorage.deleteAll();
      return handler.next(err);
    }

    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _secureStorage.deleteAll();
      return handler.next(err);
    }

    try {
      // start the refresh
      if (!_isRefreshing) {
        _isRefreshing = true;
        _refreshCompleter = Completer<String?>();

        final newAccessToken = await _refreshAccessToken(refreshToken);

        _completeOnce(newAccessToken);
        _isRefreshing = false;

        if (newAccessToken == null) {
          await _secureStorage.deleteAll();
          return handler.next(err);
        }

        final retry = await _retryRequest(err.requestOptions, newAccessToken);
        return handler.resolve(retry);
      }

      // if one request start refresh all the other request wait (refresh call just one time)
      final newAccessToken = await _refreshCompleter?.future;
      if (newAccessToken == null) return handler.next(err);

      final retry = await _retryRequest(err.requestOptions, newAccessToken);
      return handler.resolve(retry);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during token refresh: $e');
      _completeOnce(null);
      _isRefreshing = false;
      await _secureStorage.deleteAll();
      return handler.next(err);
    } finally {
      if (_isRefreshing == false) {
        _refreshCompleter = null;
      }
    }
  }

  Future<String?> _refreshAccessToken(String refreshToken) async {
    final refreshDio = Dio(_dio.options)
      ..httpClientAdapter = _dio.httpClientAdapter;

    final response = await refreshDio.post(
      _refreshPath,
      data: {'refreshToken': refreshToken},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode != 200 || response.data is! Map) return null;
    final data = response.data as Map<String, dynamic>;

    final accessToken =
        (data['accessToken'] as String?) ??
        (data['access_token'] as String?) ??
        (data['token'] as String?);

    final newRefreshToken =
        (data['refreshToken'] as String?) ?? (data['refresh_token'] as String?);

    if (accessToken == null || accessToken.isEmpty) return null;

    await _secureStorage.setToken(accessToken);
    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
      await _secureStorage.setRefreshToken(newRefreshToken);
    }

    return accessToken;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer $accessToken',
        },
      ),
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}