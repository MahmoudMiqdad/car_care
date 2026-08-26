// اختبار موجّه لدفعة A0B: يثبت أن LoggingInterceptor لا يطبع مطلقًا محتوى
// الـ body أو الـ headers — فقط method/url/status — بغض النظر عمّا تحتويه
// بيانات الطلب أو الاستجابة (بما فيها كلمات مرور وTokens حقيقية).
import 'package:car_care/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
 final interceptor = LoggingInterceptor.i;

  late List<String> printed;
  late DebugPrintCallback originalDebugPrint;

  setUp(() {
    printed = [];
    originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) printed.add(message);
    };
  });

  tearDown(() {
    debugPrint = originalDebugPrint;
  });

  const secrets = [
    'SuperSecret123',
    'user@test.com',
    'my-access-token-abc',
    'my-refresh-token-xyz',
    '123456', // otp/code
  ];

  bool anyLineLeaksASecret() =>
      printed.any((line) => secrets.any((secret) => line.contains(secret)));

  test('onRequest with a login-shaped body never prints the body', () {
    final options = RequestOptions(
      path: '/auth/login',
      method: 'POST',
      data: {'email': 'user@test.com', 'password': 'SuperSecret123'},
      headers: {'Authorization': 'Bearer my-access-token-abc'},
    );

    interceptor.onRequest(options, MockRequestInterceptorHandler());

    expect(printed, isNotEmpty, reason: 'method/url line should still log');
    expect(anyLineLeaksASecret(), isFalse);
  });

  test(
    'onResponse with a token-bearing login response never prints the body',
    () {
      final requestOptions = RequestOptions(
        path: '/auth/login',
        method: 'POST',
      );
      final response = Response<Map<String, dynamic>>(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {
          'access_token': 'my-access-token-abc',
          'refresh_token': 'my-refresh-token-xyz',
        },
      );

      interceptor.onResponse(response, MockResponseInterceptorHandler());

      expect(printed, isNotEmpty);
      expect(anyLineLeaksASecret(), isFalse);
    },
  );

  test(
    'onError with a response body containing credentials never prints it',
    () {
      final requestOptions = RequestOptions(
        path: '/auth/login',
        method: 'POST',
      );
      final response = Response<Map<String, dynamic>>(
        requestOptions: requestOptions,
        statusCode: 422,
        data: {'message': 'validation error', 'password': 'SuperSecret123'},
      );
      final err = DioException(
        requestOptions: requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

      interceptor.onError(err, MockErrorInterceptorHandler());

      expect(printed, isNotEmpty);
      expect(anyLineLeaksASecret(), isFalse);
    },
  );

  test('printed lines only ever contain method/url/status metadata', () {
    final options = RequestOptions(
      path: '/auth/register',
      method: 'POST',
      data: {
        'password': 'SuperSecret123',
        'password_confirmation': 'SuperSecret123',
        'otp': '123456',
      },
    );

    interceptor.onRequest(options, MockRequestInterceptorHandler());

    expect(printed, hasLength(1));
    expect(printed.single, contains('POST'));
    expect(printed.single, contains('/auth/register'));
  });
}
