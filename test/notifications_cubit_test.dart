// اختبارات NotificationsCubit: تحميل القائمة، unread count، mark-as-read،
// mark-all-as-read، delete، refresh، وفلترة All/Unread، والإشعارات
// اللحظية (Phase 2 realtime) — كل ذلك بدون full reload غير ضروري.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service/pusher_service.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements INotificationsRepository {}

class MockPusherService extends Mock implements PusherService {}

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
    createdAt: DateTime(2026, 8, 18, 10),
  );
}

void main() {
  late MockNotificationsRepository repo;
  late NotificationsCubit cubit;

  setUp(() {
    repo = MockNotificationsRepository();
    cubit = NotificationsCubit(repo);
  });

  group('getNotifications', () {
    test('success maps items and unreadCount from the repository result', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null), _fake(id: '2', readAt: DateTime.now())],
            unreadCount: 1,
          ),
        ),
      );

      await cubit.getNotifications();

      final state = cubit.state as NotificationsLoaded;
      expect(state.items, hasLength(2));
      expect(state.unreadCount, 1);
      expect(state.filter, NotificationsFilter.all);
    });

    test('an empty list maps to a Loaded state with an empty items list', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => const Right(NotificationsListResult(items: [], unreadCount: 0)),
      );

      await cubit.getNotifications();

      final state = cubit.state as NotificationsLoaded;
      expect(state.items, isEmpty);
    });

    test('a failure on first load emits NotificationsError', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل الجلب')),
      );

      await cubit.getNotifications();

      expect(cubit.state, isA<NotificationsError>());
      expect((cubit.state as NotificationsError).message, 'فشل الجلب');
    });

    test('a silent refresh reloads the list without an intermediate Loading state', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1'), _fake(id: '2')],
            unreadCount: 0,
          ),
        ),
      );

      final emitted = <NotificationsState>[];
      final sub = cubit.stream.listen(emitted.add);
      await cubit.getNotifications(silent: true);
      await sub.cancel();

      expect(emitted, isNot(contains(isA<NotificationsLoading>())));
      expect((cubit.state as NotificationsLoaded).items, hasLength(2));
      verify(() => repo.getNotifications(unread: null)).called(2);
    });
  });

  group('setFilter', () {
    test('switching to Unread calls the repository with unread: true', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1')], unreadCount: 1),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.getNotifications(unread: true)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );

      await cubit.setFilter(NotificationsFilter.unread);

      verify(() => repo.getNotifications(unread: true)).called(1);
      expect((cubit.state as NotificationsLoaded).filter, NotificationsFilter.unread);
    });
  });

  group('markAsRead', () {
    test('success updates the item locally and decrements unreadCount without a reload', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.markAsRead('1')).thenAnswer((_) async => const Right(null));

      await cubit.markAsRead('1');

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.single.isUnread, isFalse);
      expect(state.unreadCount, 0);
      verify(() => repo.getNotifications(unread: null)).called(1);
    });

    test('failure leaves the item unread and sets actionError', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.markAsRead('1')).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل التحديد كمقروء')),
      );

      await cubit.markAsRead('1');

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.single.isUnread, isTrue);
      expect(state.unreadCount, 1);
      expect(state.actionError, 'فشل التحديد كمقروء');
    });

    test('tapping an already-read item makes no repository call and leaves count unchanged', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: DateTime.now())],
            unreadCount: 0,
          ),
        ),
      );
      await cubit.getNotifications();

      await cubit.markAsRead('1');

      verifyNever(() => repo.markAsRead(any()));
      expect((cubit.state as NotificationsLoaded).unreadCount, 0);
    });
  });

  group('markAllAsRead', () {
    test('success marks every item read and zeroes unreadCount', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null), _fake(id: '2', readAt: null)],
            unreadCount: 2,
          ),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.markAllAsRead()).thenAnswer((_) async => const Right(null));

      await cubit.markAllAsRead();

      final state = cubit.state as NotificationsLoaded;
      expect(state.unreadCount, 0);
      expect(state.items.every((n) => !n.isUnread), isTrue);
    });

    test('failure keeps the existing unreadCount and items unread', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null), _fake(id: '2', readAt: null)],
            unreadCount: 2,
          ),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.markAllAsRead()).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل تحديد الكل كمقروء')),
      );

      await cubit.markAllAsRead();

      final state = cubit.state as NotificationsLoaded;
      expect(state.unreadCount, 2);
      expect(state.items.every((n) => n.isUnread), isTrue);
      expect(state.actionError, 'فشل تحديد الكل كمقروء');
    });
  });

  group('deleteNotification', () {
    test('success removes only the targeted item and decrements unreadCount', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null), _fake(id: '2', readAt: DateTime.now())],
            unreadCount: 1,
          ),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.deleteNotification('1')).thenAnswer((_) async => const Right(null));

      await cubit.deleteNotification('1');

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['2']);
      expect(state.unreadCount, 0);
    });

    test('deleting a read notification leaves unreadCount unchanged', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: DateTime.now()), _fake(id: '2', readAt: null)],
            unreadCount: 1,
          ),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.deleteNotification('1')).thenAnswer((_) async => const Right(null));

      await cubit.deleteNotification('1');

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['2']);
      expect(state.unreadCount, 1);
    });

    test('failure keeps the item in the list, count and actionError unmutated otherwise', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null)],
            unreadCount: 1,
          ),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.deleteNotification('1')).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل الحذف')),
      );

      await cubit.deleteNotification('1');

      final state = cubit.state as NotificationsLoaded;
      expect(state.items, hasLength(1));
      expect(state.items.single.id, '1');
      expect(state.unreadCount, 1);
      expect(state.actionError, 'فشل الحذف');
    });
  });

  group('fetchUnreadCount', () {
    test('updates unreadCount on the Initial state for the badge', () async {
      when(() => repo.getUnreadCount()).thenAnswer((_) async => const Right(3));

      await cubit.fetchUnreadCount();

      expect(cubit.state.unreadCount, 3);
    });
  });

  group('reset — session/logout hardening', () {
    test('clears a loaded session back to a clean NotificationsInitial(0)', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: '1', readAt: null), _fake(id: '2', readAt: null)],
            unreadCount: 5,
          ),
        ),
      );
      await cubit.getNotifications();
      expect((cubit.state as NotificationsLoaded).items, hasLength(2));
      expect(cubit.state.unreadCount, 5);

      cubit.reset();

      expect(cubit.state, isA<NotificationsInitial>());
      expect(cubit.state.unreadCount, 0);
    });

    test(
      'a second user session that reuses this singleton after reset() never '
      'observes the first user\'s items, unreadCount, filter or actionError',
      () async {
        // User A: loaded, 2 unread items, an unread filter and a pending
        // actionError from a failed action.
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(
              items: [_fake(id: 'a1', readAt: null), _fake(id: 'a2', readAt: null)],
              unreadCount: 2,
            ),
          ),
        );
        await cubit.getNotifications();
        when(() => repo.deleteNotification('a1')).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل حذف إشعار المستخدم A')),
        );
        await cubit.deleteNotification('a1');
        expect((cubit.state as NotificationsLoaded).actionError, isNotNull);

        // Logout: the app's logout flow calls reset() before navigating to
        // the login screen.
        cubit.reset();

        // User B signs in and the singleton is reused (it is a
        // registerLazySingleton fed at the app root — the same instance
        // survives the whole logout->login handoff).
        expect(cubit.state, isA<NotificationsInitial>());
        expect(cubit.state.unreadCount, 0);

        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(items: [_fake(id: 'b1', readAt: null)], unreadCount: 1),
          ),
        );
        await cubit.getNotifications();

        final state = cubit.state as NotificationsLoaded;
        expect(state.items.map((n) => n.id), ['b1']);
        expect(state.unreadCount, 1);
        expect(state.actionError, isNull);
        expect(state.filter, NotificationsFilter.all);
      },
    );
  });

  group('actionError — snackbar stability', () {
    test('clearActionError removes the error without touching items/unreadCount, and a repeated clear is a no-op', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: '1', readAt: null)], unreadCount: 1),
        ),
      );
      await cubit.getNotifications();

      when(() => repo.markAsRead('1')).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل')),
      );
      await cubit.markAsRead('1');
      expect((cubit.state as NotificationsLoaded).actionError, 'فشل');

      final emitted = <NotificationsState>[];
      final sub = cubit.stream.listen(emitted.add);

      cubit.clearActionError();
      // Calling it again once already cleared must not re-emit — this is
      // what stops the UI listener from showing the snackbar a second time.
      cubit.clearActionError();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(emitted, hasLength(1));
      final cleared = emitted.single as NotificationsLoaded;
      expect(cleared.actionError, isNull);
      expect(cleared.unreadCount, 1);
      expect(cleared.items.single.isUnread, isTrue);
    });
  });

  group('realtime — insertRealtimeNotification (Phase 2)', () {
    test('inserts a new unread notification at the top of the list', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();

      cubit.insertRealtimeNotification(_fake(id: 'new', readAt: null));

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['new', 'old']);
    });

    test('increments unreadCount exactly once for a new unread notification', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();

      cubit.insertRealtimeNotification(_fake(id: 'new', readAt: null));

      expect((cubit.state as NotificationsLoaded).unreadCount, 1);
    });

    test('a duplicate UUID is never inserted twice', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: 'dup', readAt: null)],
            unreadCount: 1,
          ),
        ),
      );
      await cubit.getNotifications();

      cubit.insertRealtimeNotification(_fake(id: 'dup', readAt: null));

      expect((cubit.state as NotificationsLoaded).items, hasLength(1));
    });

    test('a duplicate UUID does not increment unreadCount twice', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(
            items: [_fake(id: 'dup', readAt: null)],
            unreadCount: 1,
          ),
        ),
      );
      await cubit.getNotifications();

      cubit.insertRealtimeNotification(_fake(id: 'dup', readAt: null));

      expect((cubit.state as NotificationsLoaded).unreadCount, 1);
    });

    test('an incoming unread notification still appears while the Unread filter is active', () async {
      when(() => repo.getNotifications(unread: true)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old', readAt: null)], unreadCount: 1),
        ),
      );
      await cubit.getNotifications(filter: NotificationsFilter.unread);

      cubit.insertRealtimeNotification(_fake(id: 'new', readAt: null));

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['new', 'old']);
      expect(state.unreadCount, 2);
    });

    test('a realtime payload that is already read does not increment unreadCount', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();

      cubit.insertRealtimeNotification(
        _fake(id: 'new', readAt: DateTime.now()),
      );

      final state = cubit.state as NotificationsLoaded;
      expect(state.unreadCount, 0);
      expect(state.items.map((n) => n.id), contains('new'));
    });

    test('while Initial/Loading/Error, only the badge count is bumped — no fabricated list', () async {
      // cubit starts NotificationsInitial(0)
      cubit.insertRealtimeNotification(_fake(id: 'x', readAt: null));

      expect(cubit.state, isA<NotificationsInitial>());
      expect(cubit.state.unreadCount, 1);
    });

    test('reset clears realtime-derived items and unreadCount just like any other state', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();
      cubit.insertRealtimeNotification(_fake(id: 'new', readAt: null));
      expect((cubit.state as NotificationsLoaded).unreadCount, 1);

      cubit.reset();

      expect(cubit.state, isA<NotificationsInitial>());
      expect(cubit.state.unreadCount, 0);
    });

    test('a REST refresh after a realtime insert remains the source of truth', () async {
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications();
      cubit.insertRealtimeNotification(_fake(id: 'realtime-only', readAt: null));
      expect((cubit.state as NotificationsLoaded).items, hasLength(2));

      // A later REST fetch (e.g. pull-to-refresh) never saw that item —
      // its own response fully replaces the list and unreadCount.
      when(() => repo.getNotifications(unread: null)).thenAnswer(
        (_) async => Right(
          NotificationsListResult(items: [_fake(id: 'old')], unreadCount: 0),
        ),
      );
      await cubit.getNotifications(silent: true);

      final state = cubit.state as NotificationsLoaded;
      expect(state.items.map((n) => n.id), ['old']);
      expect(state.unreadCount, 0);
    });
  });

  group('realtime — subscribe/unsubscribe lifecycle', () {
    late MockPusherService pusher;

    setUpAll(() {
      registerFallbackValue('');
      final RawEventCallback fakeOnEvent = (_) {};
      registerFallbackValue(fakeOnEvent);
      final BroadcastAuthProvider fakeAuthProvider =
          ({required socketId, required channelName}) async => null;
      registerFallbackValue(fakeAuthProvider);
    });

    setUp(() {
      pusher = MockPusherService();
      when(
        () => pusher.subscribeToPrivateChannel(
          channelName: any(named: 'channelName'),
          eventName: any(named: 'eventName'),
          onEvent: any(named: 'onEvent'),
          authProvider: any(named: 'authProvider'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => pusher.unsubscribeFromPrivateChannel(any()),
      ).thenAnswer((_) async {});
      cubit = NotificationsCubit(repo, pusher: pusher);
    });

    test('subscribeRealtime subscribes to private-notifications.<userId>', () {
      cubit.subscribeRealtime(10);

      verify(
        () => pusher.subscribeToPrivateChannel(
          channelName: 'private-notifications.10',
          eventName: 'notification.created',
          onEvent: any(named: 'onEvent'),
          authProvider: any(named: 'authProvider'),
        ),
      ).called(1);
    });

    test(
      'subscribeRealtime called twice for the same user re-forwards to '
      'PusherService.subscribeToPrivateChannel both times, without '
      'unsubscribing in between — PusherService itself is the source of '
      'truth for whether a duplicate subscribe frame is actually needed, so '
      'a stuck first attempt (e.g. one-off /broadcasting/auth failure) can '
      'still be retried by a later Home load',
      () {
        cubit.subscribeRealtime(10);
        cubit.subscribeRealtime(10);

        verify(
          () => pusher.subscribeToPrivateChannel(
            channelName: 'private-notifications.10',
            eventName: any(named: 'eventName'),
            onEvent: any(named: 'onEvent'),
            authProvider: any(named: 'authProvider'),
          ),
        ).called(2);
        verifyNever(() => pusher.unsubscribeFromPrivateChannel(any()));
      },
    );

    test('reset unsubscribes the active realtime channel', () {
      cubit.subscribeRealtime(10);

      cubit.reset();

      verify(
        () => pusher.unsubscribeFromPrivateChannel('private-notifications.10'),
      ).called(1);
    });
  });

  group('session isolation — User A logout, User B login (critical)', () {
    late MockPusherService pusher;
    RawEventCallback? capturedCallback;

    setUpAll(() {
      registerFallbackValue('');
      final RawEventCallback fakeOnEvent = (_) {};
      registerFallbackValue(fakeOnEvent);
      final BroadcastAuthProvider fakeAuthProvider =
          ({required socketId, required channelName}) async => null;
      registerFallbackValue(fakeAuthProvider);
    });

    setUp(() {
      pusher = MockPusherService();
      capturedCallback = null;
      when(
        () => pusher.subscribeToPrivateChannel(
          channelName: any(named: 'channelName'),
          eventName: any(named: 'eventName'),
          onEvent: any(named: 'onEvent'),
          authProvider: any(named: 'authProvider'),
        ),
      ).thenAnswer((invocation) async {
        capturedCallback =
            invocation.namedArguments[#onEvent] as RawEventCallback;
      });
      when(
        () => pusher.unsubscribeFromPrivateChannel(any()),
      ).thenAnswer((_) async {});
      cubit = NotificationsCubit(repo, pusher: pusher);
    });

    Map<String, dynamic> payload(String id) => {
      'id': id,
      'type': 'sos_created',
      'title': 'عنوان',
      'body': 'نص',
      'data': <String, dynamic>{},
      'read_at': null,
      'created_at': '2026-08-18T10:00:00.000000Z',
    };

    test(
      'User A subscribes to notifications.10, logs out, User B subscribes to '
      'notifications.20 — the old channel is torn down, User B\'s channel is '
      'the active one, and a stray event from A\'s superseded callback never '
      'reaches the cubit',
      () async {
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => const Right(NotificationsListResult(items: [], unreadCount: 0)),
        );
        await cubit.getNotifications();

        // User A subscribes.
        cubit.subscribeRealtime(10);
        final userAsStaleCallback = capturedCallback!;
        verify(
          () => pusher.subscribeToPrivateChannel(
            channelName: 'private-notifications.10',
            eventName: any(named: 'eventName'),
            onEvent: any(named: 'onEvent'),
            authProvider: any(named: 'authProvider'),
          ),
        ).called(1);

        // Logout.
        cubit.reset();
        verify(
          () => pusher.unsubscribeFromPrivateChannel('private-notifications.10'),
        ).called(1);
        expect(cubit.state, isA<NotificationsInitial>());

        // User B logs in and subscribes.
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => const Right(NotificationsListResult(items: [], unreadCount: 0)),
        );
        await cubit.getNotifications();
        cubit.subscribeRealtime(20);
        verify(
          () => pusher.subscribeToPrivateChannel(
            channelName: 'private-notifications.20',
            eventName: any(named: 'eventName'),
            onEvent: any(named: 'onEvent'),
            authProvider: any(named: 'authProvider'),
          ),
        ).called(1);

        // A stray event arrives late through User A's now-superseded
        // callback closure (e.g. PusherService hadn't fully torn it down
        // yet) — the cubit's own userId guard must still drop it.
        userAsStaleCallback(payload('from-user-A'));

        final stateAfterStrayEvent = cubit.state as NotificationsLoaded;
        expect(stateAfterStrayEvent.items, isEmpty);
        expect(stateAfterStrayEvent.unreadCount, 0);

        // A genuine event through User B's active callback still works.
        capturedCallback!(payload('from-user-B'));

        final finalState = cubit.state as NotificationsLoaded;
        expect(finalState.items.single.id, 'from-user-B');
        expect(finalState.unreadCount, 1);
      },
    );
  });
}
