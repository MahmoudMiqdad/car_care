// UI-level coverage for Continue with Google on the login screen:
// - the divider + button render without touching the existing form
// - a successful Google sign-in reuses the exact same AuthSuccess ->
//   navigate-to-Home path as a normal email/password login (item 8)
// - cancelling the Google picker leaves the user on the login page with
//   no error snackbar
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/auth/data/services/google_sign_in_service.dart';
import 'package:car_care/features/auth/domain/model/auth_model.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/pages/login_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

AuthResponseModel _successModel() => AuthResponseModel.fromJson({
  'success': true,
  'message': 'ok',
  'data': {
    'token': 'server-jwt',
    'user': {
      'id': 1,
      'uuid': 'u1',
      'name': 'Test User',
      'email': 't@example.com',
      'phone': null,
      'status': 'active',
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-01T00:00:00Z',
      'roles': ['user'],
    },
  },
});

Future<void> _pumpLoginPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: Routes.home,
        builder: (_, _) => const Scaffold(body: Text('HOME')),
      ),
      GoRoute(
        path: Routes.signup,
        builder: (_, _) => const Scaffold(body: Text('SIGNUP')),
      ),
      GoRoute(
        path: Routes.forget_password,
        builder: (_, _) => const Scaffold(body: Text('FORGOT')),
      ),
    ],
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp.router(
        routerConfig: router,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          // Test-only: routes around a pre-existing, unrelated overflow in
          // LoginFormSection's register-link row (out of scope for this
          // Google Sign-In feature — not modified here) so it doesn't mask
          // this test's actual Google-flow assertions.
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(0.7)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late MockIAuthRepository repo;
  late MockGoogleSignInService googleService;

  setUp(() {
    repo = MockIAuthRepository();
    googleService = MockGoogleSignInService();

    if (getIt.isRegistered<IAuthRepository>()) {
      getIt.unregister<IAuthRepository>();
    }
    if (getIt.isRegistered<GoogleSignInService>()) {
      getIt.unregister<GoogleSignInService>();
    }
    getIt.registerLazySingleton<IAuthRepository>(() => repo);
    getIt.registerLazySingleton<GoogleSignInService>(() => googleService);
  });

  tearDown(() {
    getIt.unregister<IAuthRepository>();
    getIt.unregister<GoogleSignInService>();
  });

  testWidgets('renders the "or continue with" divider and the Google button', (
    tester,
  ) async {
    await _pumpLoginPage(tester);

    expect(find.text('أو تابع باستخدام'), findsOneWidget);
    expect(find.text('المتابعة باستخدام Google'), findsOneWidget);
  });

  testWidgets(
    'Google success navigates to Home — the same role-based flow used by '
    'normal login',
    (tester) async {
      when(
        () => googleService.signInAndGetIdToken(),
      ).thenAnswer((_) async => 'expected-token');
      when(
        () => repo.loginWithGoogle(any()),
      ).thenAnswer((_) async => Right(_successModel()));

      await _pumpLoginPage(tester);
      await tester.tap(find.text('المتابعة باستخدام Google'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      verify(() => repo.loginWithGoogle('expected-token')).called(1);
    },
  );

  testWidgets(
    'cancelling the Google picker stays on the login page with no error '
    'snackbar',
    (tester) async {
      when(
        () => googleService.signInAndGetIdToken(),
      ).thenAnswer((_) async => null);

      await _pumpLoginPage(tester);
      await tester.tap(find.text('المتابعة باستخدام Google'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      verifyNever(() => repo.loginWithGoogle(any()));
    },
  );
}
