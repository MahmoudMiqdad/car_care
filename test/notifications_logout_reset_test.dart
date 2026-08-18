// اختبار تكامل يثبت أن مسار confirmAndLogout الفعلي (وليس فقط استدعاء
// NotificationsCubit.reset() مباشرة) يعيد ضبط الـsingleton المشترك عند
// تسجيل الخروج، بحيث لا يرث المستخدم التالي بيانات الجلسة السابقة.
//
// في ملف مستقل حتى لا يشارك متغيّر القفل top-level `_isLoggingOut` في
// logout_action.dart مع اختبارات ملف a0_auth_logout_test.dart الأخرى داخل
// نفس isolate — ذلك الملف يترك حوارًا معلّقًا في نهاية اختبار الضغط المزدوج،
// مما يُبقي القفل محجوزًا لأي اختبار لاحق في نفس الملف.
import 'dart:async';

import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:car_care/features/auth/presentation/widgets/logout_action.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockNotificationsRepository extends Mock
    implements INotificationsRepository {}

NotificationEntity _fake() => NotificationEntity(
  id: '1',
  type: 'fuel_order_accepted',
  title: 'إشعار المستخدم السابق',
  body: 'نص',
  data: const {},
  readAt: null,
  createdAt: DateTime.now(),
);

void main() {
  testWidgets(
    'confirming logout resets the shared NotificationsCubit to a clean '
    'state so the next signed-in session starts with no leftover items, '
    'unread count, filter, or actionError',
    (tester) async {
      final authRepo = MockAuthRepository();
      when(() => authRepo.logout()).thenAnswer((_) async => const Right(unit));

      final notificationsRepo = MockNotificationsRepository();
      when(() => notificationsRepo.getNotifications(unread: null)).thenAnswer(
        (_) async =>
            Right(NotificationsListResult(items: [_fake()], unreadCount: 4)),
      );

      final storage = MockSecureStorage();
      when(() => storage.clearAuth()).thenAnswer((_) async {});

      final notificationsCubit = NotificationsCubit(notificationsRepo);

      getIt.registerLazySingleton<IAuthRepository>(() => authRepo);
      getIt.registerLazySingleton<SecureStorage>(() => storage);
      getIt.registerLazySingleton<NotificationsCubit>(() => notificationsCubit);
      addTearDown(() {
        getIt.unregister<IAuthRepository>();
        getIt.unregister<SecureStorage>();
        getIt.unregister<NotificationsCubit>();
      });

      // Simulates the loaded session left behind by the previous user (User
      // A): 1 item, unreadCount 4.
      await notificationsCubit.getNotifications();
      expect((notificationsCubit.state as NotificationsLoaded).items, hasLength(1));
      expect(notificationsCubit.state.unreadCount, 4);

      late BuildContext capturedContext;
      final router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
          GoRoute(path: '/login', builder: (context, state) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      unawaited(confirmAndLogout(capturedContext));
      await tester.pump();
      expect(find.byType(AlertDialog), findsOneWidget);

      // Confirm ("logout") is always the second action button.
      await tester.tap(find.byType(TextButton).last);
      await tester.pumpAndSettle();

      // User B's session starts clean — no items, no leftover unread count.
      expect(notificationsCubit.state, isA<NotificationsInitial>());
      expect(notificationsCubit.state.unreadCount, 0);

      // And a fresh fetch for User B never merges with User A's data.
      when(() => notificationsRepo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [
              NotificationEntity(
                id: 'b1',
                type: 'sos_created',
                title: 'إشعار المستخدم الجديد',
                body: 'نص',
                data: const {},
                readAt: null,
                createdAt: DateTime.now(),
              ),
            ],
            unreadCount: 1,
          ),
        ),
      );
      await notificationsCubit.getNotifications();

      final state = notificationsCubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['b1']);
      expect(state.unreadCount, 1);
      expect(state.actionError, isNull);
    },
  );
}
