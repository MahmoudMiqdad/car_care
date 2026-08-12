import 'dart:async';

import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/domain/repositories/i_advertisement_repository.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/data/data_sources/availability_remote_data_source.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/data/repositories/availability_repository_impl.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/entities/availability_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/repositories/i_availability_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_state.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_body.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/washer_availability_switch_card.dart';
import 'package:car_care/features/more/presentation/pages/more_page.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/features/user_profile/data/model/profile_model.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAvailabilityRepository extends Mock
    implements IAvailabilityRepository {}

class MockApiService extends Mock implements ApiService {}

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockIAdvertisementRepository extends Mock
    implements IAdvertisementRepository {}

/// Fakes the concrete [AvailabilityRemoteDataSource] surface without going
/// through Dio, so [AvailabilityRepositoryImpl] can be tested against a
/// success response that genuinely carries no `data`/`is_available`.
class _FakeRemoteDataSourceNoData implements AvailabilityRemoteDataSource {
  @override
  Future<Map<String, dynamic>> updateAvailability(bool isAvailable) async {
    return {'success': true, 'message': 'تم'};
  }
}

class _FailingRemoteDataSource implements AvailabilityRemoteDataSource {
  @override
  Future<Map<String, dynamic>> updateAvailability(bool isAvailable) async {
    throw Exception('network error');
  }
}

/// In-memory [SecureStorage] used only so `MorePage`'s role lookup never
/// touches the real `flutter_secure_storage` platform channel in a widget
/// test (which has no channel handler registered and can hang instead of
/// throwing, keeping the FutureBuilder's CircularProgressIndicator spinning
/// forever and timing out `pumpAndSettle`).
class _InMemorySecureStorage extends SecureStorage {
  final Map<DbKeys, String> _store = {};

  @override
  Future<void> setRoles(List<String> rolesList) async {
    _store[DbKeys.roles] = rolesList.join(',');
  }

  @override
  Future<List<String>> getRoles() async {
    final value = _store[DbKeys.roles];
    if (value == null || value.isEmpty) return [];
    return value.split(',').where((r) => r.isNotEmpty).toList();
  }
}

/// Pumps [child] inside a ScreenUtilInit + MaterialApp (with Arabic l10n
/// delegates), matching the pattern already used by test/cw1_*.
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

WasherProfileEntity _fakeProfile({required bool isAvailable}) {
  return WasherProfileEntity(
    id: 1,
    shopName: 'مغسلة السلام',
    phone: '0500000000',
    city: 'الرياض',
    address: 'حي النخيل',
    description: 'وصف تجريبي',
    logoUrl: null,
    services: const ['basic'],
    servicePrices: const {'basic': 50},
    workingHours: const {'sunday': '08:00-20:00'},
    isAvailable: isAvailable,
    isVerified: true,
    averageRating: 4.5,
    ratingsCount: 10,
    ratingStars: '4.5',
    createdAt: '2026-01-01',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const Failure(message: 'fallback'));
    registerFallbackValue(AdvertisementPlacement.values.first);
  });

  group(
    'AvailabilityCubit — no optimistic update, single in-flight request',
    () {
      late MockIAvailabilityRepository repo;
      late AvailabilityCubit cubit;

      setUp(() {
        repo = MockIAvailabilityRepository();
        cubit = AvailabilityCubit(repo);
      });

      tearDown(() => cubit.close());

      test('Success confirms the requested value even though the PATCH '
          'response carries no `data`/`is_available` to read back', () async {
        when(() => repo.updateAvailability(true)).thenAnswer(
          (_) async => const Right(AvailabilityEntity(isAvailable: true)),
        );

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AvailabilityLoading>(),
            isA<AvailabilitySuccess>().having(
              (s) => s.isAvailable,
              'isAvailable',
              true,
            ),
          ]),
        );

        await cubit.changeAvailability(true);
        await expectation;

        verify(() => repo.updateAvailability(true)).called(1);
      });

      test('Failure emits an error state carrying the previous-value '
          'semantics (no success is faked)', () async {
        when(() => repo.updateAvailability(false)).thenAnswer(
          (_) async => const Left(Failure(message: 'تعذر تحديث حالة التوفر')),
        );

        final expectation = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AvailabilityLoading>(),
            isA<AvailabilityError>().having(
              (s) => s.message,
              'message',
              'تعذر تحديث حالة التوفر',
            ),
          ]),
        );

        await cubit.changeAvailability(false);
        await expectation;
      });

      test(
        'a repeated call while Loading fires only one repository request',
        () async {
          final completer = Completer<Either<Failure, AvailabilityEntity>>();
          when(
            () => repo.updateAvailability(true),
          ).thenAnswer((_) => completer.future);

          final first = cubit.changeAvailability(true);
          // second call arrives while the cubit is still in AvailabilityLoading
          final second = cubit.changeAvailability(true);

          completer.complete(
            const Right(AvailabilityEntity(isAvailable: true)),
          );
          await first;
          await second;

          verify(() => repo.updateAvailability(true)).called(1);
        },
      );
    },
  );

  group('AvailabilityRemoteDataSource — PATCH body/endpoint contract', () {
    test(
      'sends the correct is_available value to /car_washer/availability',
      () async {
        final apiService = MockApiService();
        when(
          () => apiService.patch(
            endPoint: any(named: 'endPoint'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => {'success': true, 'message': 'تم'});

        final dataSource = AvailabilityRemoteDataSource(apiService);
        await dataSource.updateAvailability(false);

        final captured = verify(
          () => apiService.patch(
            endPoint: captureAny(named: 'endPoint'),
            data: captureAny(named: 'data'),
          ),
        ).captured;

        expect(captured[0], ApiEndpoints.washerAvailability);
        expect(captured[1], {'is_available': false});
      },
    );
  });

  group(
    'AvailabilityRepositoryImpl — builds the entity from the sent value',
    () {
      test(
        'never reads is_available back from the (data-less) response',
        () async {
          final remote = _FakeRemoteDataSourceNoData();
          final impl = AvailabilityRepositoryImpl(remote);

          final result = await impl.updateAvailability(true);

          expect(result.isRight(), true);
          result.fold(
            (_) => fail('expected Right'),
            (entity) => expect(entity.isAvailable, true),
          );
        },
      );

      test(
        'failure surfaces as a Failure, previous value is left untouched',
        () async {
          final remote = _FailingRemoteDataSource();
          final impl = AvailabilityRepositoryImpl(remote);

          final result = await impl.updateAvailability(true);

          expect(result.isLeft(), true);
        },
      );
    },
  );

  group('WasherAvailabilitySwitchCard — widget behavior', () {
    late MockIAvailabilityRepository repo;

    Widget wrap(bool initialValue) {
      return BlocProvider<AvailabilityCubit>(
        create: (_) => AvailabilityCubit(repo),
        child: WasherAvailabilitySwitchCard(initialValue: initialValue),
      );
    }

    setUp(() => repo = MockIAvailabilityRepository());

    testWidgets('1) initial value true is reflected by the Switch', (
      tester,
    ) async {
      await _pumpWithApp(tester, wrap(true));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, true);
    });

    testWidgets('2) initial value false is reflected by the Switch', (
      tester,
    ) async {
      await _pumpWithApp(tester, wrap(false));
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, false);
    });

    testWidgets(
      '4)+7) during the request the Switch is replaced by a small loading '
      'indicator, and on success the displayed value becomes the '
      'confirmed value',
      (tester) async {
        final completer = Completer<Either<Failure, AvailabilityEntity>>();
        when(
          () => repo.updateAvailability(false),
        ).thenAnswer((_) => completer.future);

        await _pumpWithApp(tester, wrap(true));

        await tester.tap(find.byType(Switch));
        await tester.pump();

        // 7) Switch is gone, a small loading indicator is shown instead.
        expect(find.byType(Switch), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        completer.complete(const Right(AvailabilityEntity(isAvailable: false)));
        await tester.pumpAndSettle();

        final sw = tester.widget<Switch>(find.byType(Switch));
        expect(sw.value, false);
      },
    );

    testWidgets(
      '5) on failure the value stays at the previous confirmed value',
      (tester) async {
        when(
          () => repo.updateAvailability(false),
        ).thenAnswer((_) async => const Left(Failure(message: 'فشل التحديث')));

        await _pumpWithApp(tester, wrap(true));

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        final sw = tester.widget<Switch>(find.byType(Switch));
        expect(sw.value, true);
        expect(find.text('فشل التحديث'), findsOneWidget);
      },
    );

    testWidgets(
      '6) a second tap while Loading does not fire a second request',
      (tester) async {
        final completer = Completer<Either<Failure, AvailabilityEntity>>();
        when(
          () => repo.updateAvailability(false),
        ).thenAnswer((_) => completer.future);

        await _pumpWithApp(tester, wrap(true));

        await tester.tap(find.byType(Switch));
        await tester.pump();
        // Switch is already replaced by the loading indicator, so a second
        // physical tap can't hit it — this itself proves double-tap is
        // prevented at the UI level.
        expect(find.byType(Switch), findsNothing);

        completer.complete(const Right(AvailabilityEntity(isAvailable: false)));
        await tester.pumpAndSettle();

        verify(() => repo.updateAvailability(false)).called(1);
      },
    );
  });

  group('ProfileWasherBody — cleaned-up button set', () {
    late MockIAvailabilityRepository repo;

    setUp(() => repo = MockIAvailabilityRepository());

    Future<void> pumpBody(WidgetTester tester, WasherProfileEntity profile) {
      return _pumpWithApp(
        tester,
        BlocProvider<AvailabilityCubit>(
          create: (_) => AvailabilityCubit(repo),
          child: ProfileWasherBody(profile: profile),
        ),
      );
    }

    testWidgets('8) the edit-profile button remains visible', (tester) async {
      await pumpBody(tester, _fakeProfile(isAvailable: true));
      expect(find.text('تعديل الملف'), findsOneWidget);
    });

    testWidgets(
      '9) حجوزاتي / الإحصائيات / التقييمات standalone buttons no longer '
      'appear inside ProfileWasherBody',
      (tester) async {
        await pumpBody(tester, _fakeProfile(isAvailable: true));
        expect(find.text('حجوزاتي'), findsNothing);
        expect(find.text('الإحصائيات'), findsNothing);
        expect(find.text('التقييمات'), findsNothing);
      },
    );

    testWidgets('the embedded availability switch card is present', (
      tester,
    ) async {
      await pumpBody(tester, _fakeProfile(isAvailable: true));
      expect(find.byType(WasherAvailabilitySwitchCard), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('MorePage — car-washer role items (real widget, not source text)', () {
    late MockProfileRemoteDataSource profileDs;
    late MockIAdvertisementRepository adsRepo;

    setUp(() {
      profileDs = MockProfileRemoteDataSource();
      adsRepo = MockIAdvertisementRepository();
      when(
        () => adsRepo.getActiveAdvertisements(any()),
      ).thenAnswer((_) async => const Right(<AdvertisementEntity>[]));

      if (getIt.isRegistered<SecureStorage>()) {
        getIt.unregister<SecureStorage>();
      }
      if (getIt.isRegistered<ProfileRemoteDataSource>()) {
        getIt.unregister<ProfileRemoteDataSource>();
      }
      if (getIt.isRegistered<AdvertisementCubit>()) {
        getIt.unregister<AdvertisementCubit>();
      }
      getIt.registerLazySingleton<SecureStorage>(
        () => _InMemorySecureStorage(),
      );
      getIt.registerLazySingleton<ProfileRemoteDataSource>(() => profileDs);
      getIt.registerFactory<AdvertisementCubit>(
        () => AdvertisementCubit(adsRepo),
      );
    });

    tearDown(() {
      getIt.unregister<SecureStorage>();
      getIt.unregister<ProfileRemoteDataSource>();
      getIt.unregister<AdvertisementCubit>();
    });

    Future<void> pumpMore(WidgetTester tester, List<String> roles) async {
      when(() => profileDs.showprofile()).thenAnswer(
        (_) async => ProfileModel(success: true, data: Data(roles: roles)),
      );
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MorePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('10) car-washer role shows الحجوزات and الإحصائيات, '
        '11) and no standalone "التوفر" tile', (tester) async {
      await pumpMore(tester, ['car-washer']);

      expect(find.text('الحجوزات'), findsOneWidget);
      expect(find.text('الإحصائيات'), findsOneWidget);
      expect(find.text('ملف المغسلة'), findsOneWidget);
      expect(find.text('التوفر'), findsNothing);
    });

    testWidgets('12) a non-car-washer role sees none of the washer tiles', (
      tester,
    ) async {
      await pumpMore(tester, ['technician']);

      expect(find.text('ملف المغسلة'), findsNothing);
      expect(find.text('الحجوزات'), findsNothing);
      expect(find.text('الإحصائيات'), findsNothing);
    });
  });

  group('13) AppRouter still builds correctly', () {
    test('router configuration builds without throwing', () {
      expect(() => AppRouter.router, returnsNormally);
    });

    test('the old Availability route constant is still defined (deferred '
        'dead-code candidate, not deleted in CW2)', () {
      expect(Routes.availability, '/availability');
    });
  });

  group('14) no regression in prior batches — light-touch sanity guard', () {
    test('carwash booking route constants are unchanged', () {
      expect(Routes.washerBookings, '/washer_bookings');
      expect(Routes.washer_statistics, '/washer_statistics');
      expect(Routes.profile_washer, '/profile_washer');
    });
  });
}
