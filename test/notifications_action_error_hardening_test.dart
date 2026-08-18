// اختبارات Action Error Hardening للإشعارات: فشل mark-as-read أو delete
// يجب ألا يستبدل القائمة بـ ErrorStateWidget — تبقى القائمة ظاهرة مع
// Snackbar فقط، بنفس فلسفة SOS/Fuel الموجودة في المشروع.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
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
  DateTime? readAt,
}) {
  return NotificationEntity(
    id: id,
    type: 'fuel_order_accepted',
    title: 'عنوان فريد $id',
    body: 'نص الإشعار $id',
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
  // AppLoadingWidget briefly shown during the initial fetch runs a perpetual
  // repeat() animation, so pumpAndSettle would never converge — pump a
  // bounded number of frames instead.
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
  group('Notifications — markAsRead action-error hardening', () {
    testWidgets(
      'a failed mark-as-read keeps the notification list on screen (no '
      'ErrorStateWidget) and shows a snackbar',
      (tester) async {
        final repo = MockNotificationsRepository();
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(
              items: [_fake(id: '1', readAt: null)],
              unreadCount: 1,
            ),
          ),
        );
        when(() => repo.markAsRead('1')).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل تحديد الإشعار كمقروء')),
        );

        _registerCubit(repo);
        addTearDown(() => getIt.unregister<NotificationsCubit>());

        await _pumpRouter(tester, _routerFor(const NotificationsPage()));

        expect(find.text('عنوان فريد 1'), findsOneWidget);
        expect(find.byType(ErrorStateWidget), findsNothing);

        await tester.tap(find.text('عنوان فريد 1'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // The item stays visible — no full-page error, no blank body.
        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.text('عنوان فريد 1'), findsOneWidget);
        expect(find.text('فشل تحديد الإشعار كمقروء'), findsOneWidget);
      },
    );
  });

  group('Notifications — delete action-error hardening', () {
    testWidgets(
      'a failed delete keeps the notification in the list and shows a '
      'snackbar instead of a full-page error',
      (tester) async {
        final repo = MockNotificationsRepository();
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(
              items: [_fake(id: '1', readAt: DateTime.now())],
              unreadCount: 0,
            ),
          ),
        );
        when(() => repo.deleteNotification('1')).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل حذف الإشعار')),
        );

        _registerCubit(repo);
        addTearDown(() => getIt.unregister<NotificationsCubit>());

        await _pumpRouter(tester, _routerFor(const NotificationsPage()));

        expect(find.text('عنوان فريد 1'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.delete_outline_rounded));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.text('عنوان فريد 1'), findsOneWidget);
        expect(find.text('فشل حذف الإشعار'), findsOneWidget);
      },
    );
  });
}
