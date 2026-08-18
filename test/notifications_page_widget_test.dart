// اختبارات واجهة صفحة الإشعارات: عرض القائمة، الحالة الفارغة، حالة الخطأ
// الأولية، الحالة البصرية للمقروء/غير المقروء، وأن الـroute الحالي ما زال
// يعمل بعد استبدال الـplaceholder.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/features/home/presentation/pages/notifications_page.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements INotificationsRepository {}

NotificationEntity _fake({
  String id = '1',
  String type = 'fuel_order_accepted',
  DateTime? readAt,
}) {
  return NotificationEntity(
    id: id,
    type: type,
    title: 'عنوان $id',
    body: 'نص $id',
    data: const {},
    readAt: readAt,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

void _registerCubit(MockNotificationsRepository repo) {
  if (getIt.isRegistered<NotificationsCubit>()) {
    getIt.unregister<NotificationsCubit>();
  }
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit(repo));
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp.router(
        routerConfig: router,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  // EmptyStateWidget/AppLoadingWidget run perpetual repeat() animations, so
  // pumpAndSettle would never converge once one of them is on screen — pump
  // a bounded number of frames instead to let the async fetch settle.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

GoRouter _routerFor(Widget page) => GoRouter(
  initialLocation: '/notifications',
  routes: [
    GoRoute(path: '/notifications', builder: (context, state) => page),
  ],
);

void main() {
  group('NotificationsPage', () {
    testWidgets('renders a loaded list with unread and read visual states', (
      tester,
    ) async {
      final repo = MockNotificationsRepository();
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [
              _fake(id: '1', readAt: null),
              _fake(id: '2', readAt: DateTime.now()),
            ],
            unreadCount: 1,
          ),
        ),
      );
      _registerCubit(repo);
      addTearDown(() => getIt.unregister<NotificationsCubit>());

      await _pumpRouter(tester, _routerFor(const NotificationsPage()));

      expect(find.text('عنوان 1'), findsOneWidget);
      expect(find.text('عنوان 2'), findsOneWidget);
      expect(find.byType(ErrorStateWidget), findsNothing);
      expect(find.byType(EmptyStateWidget), findsNothing);
    });

    testWidgets('shows the empty state when the list has no items', (
      tester,
    ) async {
      final repo = MockNotificationsRepository();
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => const Right(NotificationsListResult(items: [], unreadCount: 0)),
      );
      _registerCubit(repo);
      addTearDown(() => getIt.unregister<NotificationsCubit>());

      await _pumpRouter(tester, _routerFor(const NotificationsPage()));

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('shows ErrorStateWidget when the initial load fails', (
      tester,
    ) async {
      final repo = MockNotificationsRepository();
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => const Left(Failure(message: 'تعذر الاتصال')),
      );
      _registerCubit(repo);
      addTearDown(() => getIt.unregister<NotificationsCubit>());

      await _pumpRouter(tester, _routerFor(const NotificationsPage()));

      expect(find.byType(ErrorStateWidget), findsOneWidget);
      expect(find.text('تعذر الاتصال'), findsOneWidget);
    });

    testWidgets('the /notifications route still resolves to NotificationsPage', (
      tester,
    ) async {
      final repo = MockNotificationsRepository();
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => const Right(NotificationsListResult(items: [], unreadCount: 0)),
      );
      _registerCubit(repo);
      addTearDown(() => getIt.unregister<NotificationsCubit>());

      await _pumpRouter(tester, _routerFor(const NotificationsPage()));

      expect(find.byType(NotificationsPage), findsOneWidget);
    });

    testWidgets('tapping the Unread filter requests unread-only notifications', (
      tester,
    ) async {
      final repo = MockNotificationsRepository();
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );
      when(() => repo.getNotifications(unread: true)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );
      _registerCubit(repo);
      addTearDown(() => getIt.unregister<NotificationsCubit>());

      await _pumpRouter(tester, _routerFor(const NotificationsPage()));

      await tester.tap(find.text('غير مقروءة'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => repo.getNotifications(unread: true)).called(1);
    });
  });
}
