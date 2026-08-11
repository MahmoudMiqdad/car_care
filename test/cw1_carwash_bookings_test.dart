// اختبارات دفعة CW1-BASE: بقاء قائمة حجوزات المغسلة أثناء الإجراءات، شروط
// أزرار الحالات الخمس، ألوان الحالات الصحيحة لدى الجهتين، خيار "الكل"
// وتهجئة cancelled في الفلترين، وfallback صورة المركبة.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/core/widgets/vehicle_image_box.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/booking_status_chips.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/presentation/widgets/booking_page/filter_drop_down.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/domain/repositories/i_bookings_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/cubit/washer_bookings/bookings_state.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_card.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_filter.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_quick_actions_column.dart';
import 'package:car_care/features/car_washer/washers/washers_bookings/presentation/widgets/washer_bookings_page/washer_booking_status_chips_row.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingsRepository extends Mock implements IBookingsRepository {}

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

  group('booking status chip colors — canonical status, not the label', () {
    test('washer side: completed=success border, cancelled=error border, '
        'others neutral/transparent', () {
      expect(
        washerBookingChipStyleFor('completed').border,
        equals(const Color(0xff45B733)),
      );
      expect(
        washerBookingChipStyleFor('cancelled').border,
        equals(const Color(0xffE25839)),
      );
      for (final status in ['pending', 'accepted', 'in_progress']) {
        expect(
          washerBookingChipStyleFor(status).background,
          Colors.transparent,
        );
      }
    });

    test('customer side: same canonical rule as the washer side', () {
      expect(
        customerBookingChipStyleFor('completed').border,
        equals(const Color(0xff45B733)),
      );
      expect(
        customerBookingChipStyleFor('cancelled').border,
        equals(const Color(0xffE25839)),
      );
      for (final status in ['pending', 'accepted', 'in_progress']) {
        expect(
          customerBookingChipStyleFor(status).background,
          Colors.transparent,
        );
      }
    });

    test('an Arabic label never affects the color — only status does', () {
      // Same shape as the real bug: statusText "قيد التنفيذ" would never
      // match an English substring check, which is why every status used
      // to render identically blue. The resolver here only ever takes the
      // canonical status, never a label.
      expect(
        washerBookingChipStyleFor('in_progress').background,
        Colors.transparent,
      );
      expect(
        customerBookingChipStyleFor('in_progress').background,
        Colors.transparent,
      );
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

    // The relative-path branch reads Env.baseUrl (flutter_dotenv), which
    // needs a loaded .env in the test environment — out of scope for a
    // small, self-contained test here. The null and already-absolute
    // branches below don't touch it and cover the fallback contract that
    // matters for this batch: no image → the caller falls back to the
    // asset.
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
        // Yield once so the cubit reaches BookingActionLoading before the
        // mocked network delay resolves.
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
      // Message-only response → cubit must await exactly one re-fetch.
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

      // 'data' present but missing every field BookingModel.fromJson
      // needs (no 'vehicle' key at all) — must not throw out of the
      // cubit; must fall back to the single re-fetch instead.
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

      // Both bookings must be tracked busy at the same time.
      final state = cubit.state;
      expect(state, isA<BookingActionLoading>());
      expect(
        (state as BookingActionLoading).busyBookingIds,
        containsAll([1, 2]),
      );

      // A repeat tap on booking 1 while both are still in flight must
      // not fire a second request for it.
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

  test('completed/cancelled backgrounds are not any of the old always-blue '
      'defaults (regression guard for the "everything is blue" bug)', () {
    const oldBlues = [Color(0xFFDCECF5), Color(0xFFD1EAF8), Color(0xFFBCE5F8)];
    expect(
      oldBlues,
      isNot(contains(washerBookingChipStyleFor('completed').background)),
    );
    expect(
      oldBlues,
      isNot(contains(washerBookingChipStyleFor('cancelled').background)),
    );
    expect(
      oldBlues,
      isNot(contains(customerBookingChipStyleFor('completed').background)),
    );
    expect(
      oldBlues,
      isNot(contains(customerBookingChipStyleFor('cancelled').background)),
    );
  });
}
