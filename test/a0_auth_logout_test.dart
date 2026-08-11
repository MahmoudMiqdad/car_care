// اختبارات موجهة لدفعة A0: عقد Logout ومنع الحلقات في AuthInterceptor عند 401.
import 'dart:async';

import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/network/api_client.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/interceptors/auth_interceptor.dart';
import 'package:car_care/features/auth/presentation/widgets/logout_action.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/pump_app.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

class MockApiClient extends Mock implements ApiClient {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage secureStorage;
  late MockApiClient apiClient;
  late AuthInterceptor interceptor;
  late MockErrorInterceptorHandler handler;

  setUpAll(() {
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '/fallback')),
    );
  });

  setUp(() {
    secureStorage = MockSecureStorage();
    apiClient = MockApiClient();
    when(() => apiClient.dio).thenReturn(Dio());
    interceptor = AuthInterceptor(
      secureStorage: secureStorage,
      apiClient: apiClient,
    );
    handler = MockErrorInterceptorHandler();
    when(() => handler.next(any())).thenReturn(null);
  });

  DioException error({
    required String path,
    required int statusCode,
    Map<String, dynamic>? headers,
  }) {
    final requestOptions = RequestOptions(path: path, headers: headers ?? {});
    return DioException(
      requestOptions: requestOptions,
      response: Response(
        requestOptions: requestOptions,
        statusCode: statusCode,
      ),
    );
  }

  group('AuthInterceptor.onError — no loop / no duplicate logout', () {
    test('a 401 on the logout endpoint itself passes straight through, never '
        'attempting a refresh', () async {
      final err = error(path: ApiEndpoints.logout, statusCode: 401);

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => secureStorage.getRefreshToken());
      verifyNever(() => secureStorage.deleteAll());
    });

    test('a request already retried once (_isRetry) never loops back into a '
        'second refresh attempt', () async {
      final err = error(
        path: '/some/protected/endpoint',
        statusCode: 401,
        headers: {'_isRetry': true},
      );

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => secureStorage.getRefreshToken());
    });

    test('a 401 with no refresh token stored passes through without clearing '
        'any session data', () async {
      when(() => secureStorage.getRefreshToken()).thenAnswer((_) async => null);

      final err = error(path: '/some/protected/endpoint', statusCode: 401);

      await interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
      verifyNever(() => secureStorage.deleteAll());
    });

    test(
      'non-401 errors are never intercepted for refresh/logout logic',
      () async {
        final err = error(path: '/some/protected/endpoint', statusCode: 500);

        await interceptor.onError(err, handler);

        verify(() => handler.next(err)).called(1);
        verifyNever(() => secureStorage.getRefreshToken());
      },
    );
  });

  group('SecureStorage.clearAuth — logout session cleanup contract', () {
    late MockFlutterSecureStorage rawStorage;
    late SecureStorage storage;

    setUp(() {
      rawStorage = MockFlutterSecureStorage();
      when(
        () => rawStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => rawStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});
      storage = SecureStorage(rawStorage);
    });

    test(
      'deletes the token, refresh token, role, roles and credentials',
      () async {
        await storage.clearAuth();

        for (final key in [
          DbKeys.token,
          DbKeys.refreshToken,
          DbKeys.role,
          DbKeys.roles,
          DbKeys.username,
          DbKeys.password,
        ]) {
          verify(() => rawStorage.delete(key: key.name)).called(1);
        }
      },
    );

    test('marks the session as logged out', () async {
      await storage.clearAuth();

      verify(
        () => rawStorage.write(key: DbKeys.logged.name, value: 'false'),
      ).called(1);
    });
  });

  group(
    'confirmAndLogout — double-tap guard covers the confirmation dialog',
    () {
      testWidgets(
        'two concurrent calls before the dialog appears only ever open one '
        'AlertDialog',
        (tester) async {
          late BuildContext capturedContext;
          await tester.pumpApp(
            Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          );

          // Two calls issued back-to-back, synchronously — the lock must
          // already be held before the first `showDialog` await, so the
          // second call returns immediately instead of opening a second
          // dialog. Calling the function directly (not via tester.tap) proves
          // the guard itself, independent of the modal barrier a real second
          // tap would also be blocked by.
          unawaited(confirmAndLogout(capturedContext));
          unawaited(confirmAndLogout(capturedContext));
          await tester.pump();

          expect(find.byType(AlertDialog), findsOneWidget);

          // Dismiss via the first action button (Cancel) — confirmed != true
          // short-circuits before any getIt/API/storage call, and the lock
          // must release afterwards.
          await tester.tap(find.byType(TextButton).first);
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsNothing);

          // The lock was released on cancel — a fresh call opens the dialog
          // again instead of being silently swallowed.
          unawaited(confirmAndLogout(capturedContext));
          await tester.pump();

          expect(find.byType(AlertDialog), findsOneWidget);
        },
      );
    },
  );
}
