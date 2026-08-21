import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/repositories/i_customer_bookings_repository.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/cubit/customer_bookings/customer_bookings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/booking_status_chips.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/filter_drop_down.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_filter.dart';
import 'package:car_care/features/car_washer/shared/presentation/widgets/carwash_booking_status_badge.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/domain/repositories/i_bookings_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_card.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_filter.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_quick_actions_column.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_status_chips_row.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingsRepository extends Mock implements IBookingsRepository {}

class MockCustomerBookingsRepository extends Mock
    implements ICustomerBookingsRepository {}

Future<void> _pumpWithApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<BuildContext> _appContext(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured;
}

BookingsEntity _fakeBooking({required int id, required String status}) {
  return BookingsEntity(
    id: id,
    serviceType: 'basic',
    price: '50',
    status: status,
    statusText: status,
    scheduledAt: '2026-01-01 10:00:00',
    notes: '',
    canCancel: true,
    vehicle: const VehicleEntity(
      id: 1,
      brand: 'Toyota',
      model: 'Corolla',
      year: 2020,
      plateNumber: 'ABC-123',
      currentKm: 1000,
      status: 'active',
      needsMaintenance: false,
    ),
  );
}

Map<String, dynamic> _bookingJson({required int id, required String status}) {
  return {
    'id': id,
    'service_type': 'basic',
    'price': '50',
    'status': status,
    'status_text': status,
    'scheduled_at': '2026-01-01 10:00:00',
    'notes': '',
    'can_cancel': true,
    'vehicle': {
      'id': 1,
      'brand': 'Toyota',
      'model': 'Corolla',
      'plate_number': 'ABC-123',
    },
  };
}

void main() {
  group('washerBookingActionVisibilityFor — button set per status', () {
    test('pending shows accept/reject only', () {
      final v = washerBookingActionVisibilityFor('pending');
      expect(v.showAcceptReject, isTrue);
      expect(v.showStartComplete, isFalse);
      expect(v.showCompleteOnly, isFalse);
    });

    test('accepted shows start only — never complete alongside it', () {
      final v = washerBookingActionVisibilityFor('accepted');
      expect(v.showAcceptReject, isFalse);
      expect(v.showStartComplete, isTrue);
      expect(v.showCompleteOnly, isFalse);

      final keys = washerBookingVisibleActionKeys(
        showAcceptReject: v.showAcceptReject,
        showStartComplete: v.showStartComplete,
        showCompleteOnly: v.showCompleteOnly,
      );
      expect(keys, ['start']);
      expect(keys, isNot(contains('complete')));
    });

    test('in_progress shows complete only', () {
      final v = washerBookingActionVisibilityFor('in_progress');
      expect(v.showAcceptReject, isFalse);
      expect(v.showStartComplete, isFalse);
      expect(v.showCompleteOnly, isTrue);

      final keys = washerBookingVisibleActionKeys(
        showAcceptReject: v.showAcceptReject,
        showStartComplete: v.showStartComplete,
        showCompleteOnly: v.showCompleteOnly,
      );
      expect(keys, ['complete']);
    });

    test('completed/cancelled show no actions', () {
      for (final status in ['completed', 'cancelled']) {
        final v = washerBookingActionVisibilityFor(status);
        final keys = washerBookingVisibleActionKeys(
          showAcceptReject: v.showAcceptReject,
          showStartComplete: v.showStartComplete,
          showCompleteOnly: v.showCompleteOnly,
        );
        expect(keys, isEmpty);
      }
    });
  });

  group('booking filters — "الكل" option and cancelled spelling', () {
    test('washer filter includes a local "all" (null) option', () {
      expect(washerBookingFilterStatusKeys, contains(null));
    });

    test('customer filter includes a local "all" (null) option', () {
      expect(customerBookingFilterStatusKeys, contains(null));
    });

    test(
      'both filters use the same canonical statuses, spelled "cancelled"',
      () {
        expect(washerBookingFilterStatusKeys, contains('cancelled'));
        expect(customerBookingFilterStatusKeys, contains('cancelled'));
        expect(washerBookingFilterStatusKeys, isNot(contains('canceled')));
        expect(customerBookingFilterStatusKeys, isNot(contains('canceled')));
        expect(
          washerBookingFilterStatusKeys,
          equals(customerBookingFilterStatusKeys),
        );
      },
    );
  });

  group('resolveMediaUrl — vehicle image fallback', () {
    test('null/empty returns null so the caller falls back to the asset', () {
      expect(resolveMediaUrl(null), isNull);
      expect(resolveMediaUrl(''), isNull);
      expect(resolveMediaUrl('   '), isNull);
    });

    test('an already-absolute URL is returned as-is', () {
      expect(
        resolveMediaUrl('https://example.com/x.jpg'),
        'https://example.com/x.jpg',
      );
    });
  });

  group('BookingsCubit — an action never blanks the visible list', () {
    late MockBookingsRepository repo;
    late BookingsCubit cubit;

    setUp(() {
      repo = MockBookingsRepository();
      cubit = BookingsCubit(repo);
    });

    tearDown(() => cubit.close());

    test(
      'BookingActionLoading carries the items and status the list had',
      () async {
        final items = [_fakeBooking(id: 1, status: 'pending')];
        when(
          () => repo.getBookings(status: any(named: 'status')),
        ).thenAnswer((_) async => Right(items));
        await cubit.fetchBookings();

        when(() => repo.acceptBooking(1)).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return const Right({'message': 'تم'});
        });

        final actionFuture = cubit.acceptBooking(1);
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state, isA<BookingActionLoading>());
        final loading = cubit.state as BookingActionLoading;
        expect(loading.bookingId, 1);
        expect(loading.currentItems, items);

        await actionFuture;
      },
    );

    test('success does not produce an empty-list state when the item still '
        'matches the active filter', () async {
      final items = [_fakeBooking(id: 1, status: 'pending')];
      when(
        () => repo.getBookings(status: any(named: 'status')),
      ).thenAnswer((_) async => Right(items));
      await cubit.fetchBookings();

      when(
        () => repo.acceptBooking(1),
      ).thenAnswer((_) async => const Right({'message': 'تم القبول'}));
      when(() => repo.getBookings(status: null)).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'accepted')]),
      );

      await cubit.acceptBooking(1);

      expect(cubit.state, isA<BookingsLoaded>());
      final loaded = cubit.state as BookingsLoaded;
      expect(loaded.items, isNotEmpty);
      expect(loaded.items.single.status, 'accepted');
    });

    test(
      'an item that no longer matches the active filter disappears — '
      'the natural input to the Empty State, not a blank/broken screen',
      () async {
        var pendingCallCount = 0;
        when(() => repo.getBookings(status: 'pending')).thenAnswer((_) async {
          pendingCallCount++;
          if (pendingCallCount == 1) {
            return Right([_fakeBooking(id: 1, status: 'pending')]);
          }
          return const Right(<BookingsEntity>[]);
        });
        await cubit.fetchBookings(status: 'pending');

        when(
          () => repo.acceptBooking(1),
        ).thenAnswer((_) async => const Right({'message': 'تم القبول'}));

        await cubit.acceptBooking(1);

        expect(cubit.state, isA<BookingsLoaded>());
        expect((cubit.state as BookingsLoaded).items, isEmpty);
        expect(
          pendingCallCount,
          2,
          reason: 'exactly one re-fetch after the action',
        );
      },
    );

    test('a failed action keeps the previously-visible items', () async {
      final items = [_fakeBooking(id: 1, status: 'pending')];
      when(
        () => repo.getBookings(status: any(named: 'status')),
      ).thenAnswer((_) async => Right(items));
      await cubit.fetchBookings();

      when(
        () => repo.acceptBooking(1),
      ).thenAnswer((_) async => const Left(Failure(message: 'فشل الطلب')));

      await cubit.acceptBooking(1);

      expect(cubit.state, isA<BookingActionError>());
      final errorState = cubit.state as BookingActionError;
      expect(errorState.currentItems, items);
      expect(errorState.message, 'فشل الطلب');
    });

    test('a second call for the same booking while busy is ignored — no '
        'duplicate request', () async {
      final items = [_fakeBooking(id: 1, status: 'pending')];
      when(
        () => repo.getBookings(status: any(named: 'status')),
      ).thenAnswer((_) async => Right(items));
      await cubit.fetchBookings();

      var callCount = 0;
      when(() => repo.acceptBooking(1)).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return const Right({'message': 'تم'});
      });

      final first = cubit.acceptBooking(1);
      final second = cubit.acceptBooking(
        1,
      ); // fired while the first is in flight
      await Future.wait([first, second]);

      expect(callCount, 1);
    });

    test('response with the updated booking (data present) keeps it in place '
        'when the filter is "all"', () async {
      var fetchCount = 0;
      when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer((
        _,
      ) async {
        fetchCount++;
        return Right([_fakeBooking(id: 1, status: 'pending')]);
      });
      await cubit.fetchBookings(); // status: null => 'all'

      when(() => repo.acceptBooking(1)).thenAnswer(
        (_) async => Right({
          'message': 'تم',
          'data': _bookingJson(id: 1, status: 'accepted'),
        }),
      );

      await cubit.acceptBooking(1);

      expect(cubit.state, isA<BookingsLoaded>());
      final loaded = cubit.state as BookingsLoaded;
      expect(loaded.items, hasLength(1));
      expect(loaded.items.single.status, 'accepted');
      expect(
        fetchCount,
        1,
        reason: 'no re-fetch needed when data is already present',
      );
    });

    test('response with the updated booking (data present) removes it when it '
        'no longer matches a specific active filter', () async {
      var fetchCount = 0;
      when(() => repo.getBookings(status: 'pending')).thenAnswer((_) async {
        fetchCount++;
        return Right([_fakeBooking(id: 1, status: 'pending')]);
      });
      await cubit.fetchBookings(status: 'pending');

      when(() => repo.acceptBooking(1)).thenAnswer(
        (_) async => Right({
          'message': 'تم',
          'data': _bookingJson(id: 1, status: 'accepted'),
        }),
      );

      await cubit.acceptBooking(1);

      expect(cubit.state, isA<BookingsLoaded>());
      expect((cubit.state as BookingsLoaded).items, isEmpty);
      expect(
        fetchCount,
        1,
        reason: 'no re-fetch needed when data is already present',
      );
    });

    test('a partial/malformed data field never crashes the cubit — falls back '
        'to a single re-fetch instead', () async {
      when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'pending')]),
      );
      await cubit.fetchBookings();

      when(() => repo.acceptBooking(1)).thenAnswer(
        (_) async => const Right({
          'message': 'تم',
          'data': <String, dynamic>{'status': 'accepted'},
        }),
      );
      when(() => repo.getBookings(status: null)).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'accepted')]),
      );

      await cubit.acceptBooking(1);

      expect(cubit.state, isA<BookingsLoaded>());
      expect((cubit.state as BookingsLoaded).items.single.status, 'accepted');
    });

    test('two different bookings can be busy at the same time without one '
        'clobbering the other\'s busy tracking', () async {
      final items = [
        _fakeBooking(id: 1, status: 'pending'),
        _fakeBooking(id: 2, status: 'pending'),
      ];
      when(
        () => repo.getBookings(status: any(named: 'status')),
      ).thenAnswer((_) async => Right(items));
      await cubit.fetchBookings();

      var call1 = 0;
      var call2 = 0;
      when(() => repo.acceptBooking(1)).thenAnswer((_) async {
        call1++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Right({'message': 'تم'});
      });
      when(() => repo.acceptBooking(2)).thenAnswer((_) async {
        call2++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Right({'message': 'تم'});
      });
      when(
        () => repo.getBookings(status: null),
      ).thenAnswer((_) async => Right(items));

      final f1 = cubit.acceptBooking(1);
      await Future<void>.delayed(Duration.zero);
      final f2 = cubit.acceptBooking(2);
      await Future<void>.delayed(Duration.zero);

      final state = cubit.state;
      expect(state, isA<BookingActionLoading>());
      expect(
        (state as BookingActionLoading).busyBookingIds,
        containsAll([1, 2]),
      );

      final repeat = cubit.acceptBooking(1);

      await Future.wait([f1, f2, repeat]);

      expect(call1, 1);
      expect(call2, 1);
    });
  });

  group('vehicleImageRawValue — single shared source of truth (core/widgets/'
      'vehicle_image_box.dart), used by vehicle details and both carwash '
      'booking-details screens', () {
    test('prefers a non-empty image over imagePath', () {
      expect(vehicleImageRawValue('a.jpg', 'b.jpg'), 'a.jpg');
    });

    test('falls back to imagePath when image is null', () {
      expect(vehicleImageRawValue(null, 'b.jpg'), 'b.jpg');
    });

    test('falls back to imagePath when image is empty/whitespace-only — an '
        'empty (non-null) image must not win over a real imagePath', () {
      expect(vehicleImageRawValue('', 'b.jpg'), 'b.jpg');
      expect(vehicleImageRawValue('   ', 'b.jpg'), 'b.jpg');
    });

    test('returns null when both are missing/blank, so the caller falls '
        'back to the asset', () {
      expect(vehicleImageRawValue(null, null), isNull);
      expect(vehicleImageRawValue('', '  '), isNull);
    });
  });

  testWidgets(
    'completed/cancelled backgrounds are not any of the old always-blue '
    'defaults (regression guard for the "everything is blue" bug)',
    (tester) async {
      final context = await _appContext(tester);
      const oldBlues = [
        Color(0xFFDCECF5),
        Color(0xFFD1EAF8),
        Color(0xFFBCE5F8),
      ];
      expect(
        oldBlues,
        isNot(
          contains(
            carwashBookingStatusStyleFor(context, 'completed').background,
          ),
        ),
      );
      expect(
        oldBlues,
        isNot(
          contains(
            carwashBookingStatusStyleFor(context, 'cancelled').background,
          ),
        ),
      );
    },
  );

  group('carwashBookingFilterStatusKeys — CW1-R shared source of truth', () {
    test('six keys in order: all(null), pending, accepted, in_progress, '
        'completed, cancelled', () {
      expect(carwashBookingFilterStatusKeys, [
        null,
        'pending',
        'accepted',
        'in_progress',
        'completed',
        'cancelled',
      ]);
    });
  });

  group(
    'carwashBookingStatusStyleFor — CW1-R shared color source of truth',
    () {
      testWidgets(
        'completed=success border, cancelled=error border, others neutral, '
        'label text never affects the color',
        (tester) async {
          final context = await _appContext(tester);
          expect(
            carwashBookingStatusStyleFor(context, 'completed').border,
            equals(AppColors.green),
          );
          expect(
            carwashBookingStatusStyleFor(context, 'cancelled').border,
            equals(AppColors.red),
          );
          for (final status in ['pending', 'accepted', 'in_progress']) {
            expect(
              carwashBookingStatusStyleFor(context, status).background,
              Colors.transparent,
            );
          }
        },
      );
    },
  );

  group('CarwashBookingFilter — shared widget behavior (StatusFilterTabs)', () {
    testWidgets('renders all six statuses as tabs in canonical order and calls '
        'onChanged with the tapped status key exactly once', (tester) async {
      String? received;
      var callCount = 0;

      await _pumpWithApp(
        tester,
        CarwashBookingFilter(
          selectedStatus: 'accepted',
          onChanged: (status) {
            received = status;
            callCount++;
          },
        ),
      );

      expect(find.byType(StatusFilterTabs<String>), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('تم القبول'), findsOneWidget);

      await tester.ensureVisible(find.text('مكتمل'));
      await tester.tap(find.text('مكتمل'));
      await tester.pumpAndSettle();

      expect(callCount, 1);
      expect(received, 'completed');
    });

    testWidgets(
      'picking "الكل" calls onChanged(null) exactly once — the sentinel '
      'never leaks out to the caller',
      (tester) async {
        final picked = <String?>[];

        await _pumpWithApp(
          tester,
          CarwashBookingFilter(
            selectedStatus: 'accepted',
            onChanged: picked.add,
          ),
        );

        await tester.tap(find.text('الكل'));
        await tester.pumpAndSettle();

        expect(picked, [null]);
      },
    );

    testWidgets('with no status selected, "الكل" itself is the selected tab', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        CarwashBookingFilter(selectedStatus: null, onChanged: (_) {}),
      );

      final widget = tester.widget<StatusFilterTabs<String>>(
        find.byType(StatusFilterTabs<String>),
      );
      final allItem = widget.items.firstWhere((i) => i.label == 'الكل');

      expect(widget.selected, allItem.value);
    });
  });

  group('CustomerBookingFilter / WasherBookingFilter — wrappers still work '
      'after the tabs migration', () {
    testWidgets('CustomerBookingFilter renders through CustomerBookingsCubit', (
      tester,
    ) async {
      final repo = MockCustomerBookingsRepository();
      when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'pending')]),
      );
      final cubit = CustomerBookingsCubit(repo);
      await cubit.fetchBookings();

      await _pumpWithApp(
        tester,
        BlocProvider<CustomerBookingsCubit>.value(
          value: cubit,
          child: const CustomerBookingFilter(),
        ),
      );

      expect(find.byType(StatusFilterTabs<String>), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('WasherBookingFilter renders through BookingsCubit', (
      tester,
    ) async {
      final repo = MockBookingsRepository();
      when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'pending')]),
      );
      final cubit = BookingsCubit(repo);
      await cubit.fetchBookings();

      await _pumpWithApp(
        tester,
        BlocProvider<BookingsCubit>.value(
          value: cubit,
          child: const WasherBookingFilter(),
        ),
      );

      expect(find.byType(StatusFilterTabs<String>), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      await cubit.close();
    });

    testWidgets(
      'CustomerBookingFilter selecting a status calls fetchBookings on '
      'CustomerBookingsCubit exactly once — no duplicate request',
      (tester) async {
        final repo = MockCustomerBookingsRepository();
        when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer(
          (_) async => Right([_fakeBooking(id: 1, status: 'pending')]),
        );
        final cubit = CustomerBookingsCubit(repo);
        await cubit.fetchBookings();

        await _pumpWithApp(
          tester,
          BlocProvider<CustomerBookingsCubit>.value(
            value: cubit,
            child: const CustomerBookingFilter(),
          ),
        );

        await tester.ensureVisible(find.text('مكتمل'));
        await tester.tap(find.text('مكتمل'));
        await tester.pumpAndSettle();

        verify(() => repo.getBookings(status: 'completed')).called(1);
        await cubit.close();
      },
    );

    testWidgets('WasherBookingFilter selecting a status calls fetchBookings on '
        'BookingsCubit exactly once — no duplicate request', (tester) async {
      final repo = MockBookingsRepository();
      when(() => repo.getBookings(status: any(named: 'status'))).thenAnswer(
        (_) async => Right([_fakeBooking(id: 1, status: 'pending')]),
      );
      final cubit = BookingsCubit(repo);
      await cubit.fetchBookings();

      await _pumpWithApp(
        tester,
        BlocProvider<BookingsCubit>.value(
          value: cubit,
          child: const WasherBookingFilter(),
        ),
      );

      await tester.ensureVisible(find.text('مكتمل'));
      await tester.tap(find.text('مكتمل'));
      await tester.pumpAndSettle();

      verify(() => repo.getBookings(status: 'completed')).called(1);
      await cubit.close();
    });

    testWidgets(
      'BookingStatusChip / WasherBookingStatusChipsRow still render their '
      'label with no Cubit needed',
      (tester) async {
        await _pumpWithApp(
          tester,
          const Column(
            children: [
              BookingStatusChip(status: 'completed', label: 'مكتمل'),
              WasherBookingStatusChipsRow(status: 'cancelled', label: 'ملغي'),
            ],
          ),
        );
        expect(find.text('مكتمل'), findsOneWidget);
        expect(find.text('ملغي'), findsOneWidget);
      },
    );
  });
}
