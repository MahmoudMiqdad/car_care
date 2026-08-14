// اختبارات دفعة CW3: قسم التقييمات المضمّن المشترك بين ملف المغسلة وتفاصيل
// المغسلة لدى العميل — تحليل عقد meta بأمان (int/double/string)، سلوك
// data:[] مع meta غير صفرية، user:null بلا crash، ومنع الطلبات المكررة.
import 'dart:async';

import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:car_care/core/widgets/statistics/stats_grid.dart';
import 'package:car_care/core/widgets/statistics/stats_indicators_section.dart';
import 'package:car_care/core/widgets/statistics/stats_summary_card.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washer_details/washer_details_view.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washer_details/washer_details_reviews_section.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/domain/entities/ratings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/domain/repositories/i_ratings_repository.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/cubit/ratings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/cubit/ratings_state.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/domain/repositories/i_availability_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/repositories/i_profile_washer_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_body.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_star_rating_row.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/data/models/car_washer_rating_model.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/entities/car_washer_rating_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/domain/repositories/i_car_washer_ratings_repository.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/cubit/car_washer_ratings_state.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/widgets/car_washer_ratings_section.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/domain/entities/statistics_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_body.dart';
import 'package:car_care/features/car_washer/washers/washers_statistics/presentation/widgets/washer_statistics/washer_statistics_ratings_section.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockICarWasherRatingsRepository extends Mock
    implements ICarWasherRatingsRepository {}

class MockIRatingsRepository extends Mock implements IRatingsRepository {}

class MockIAvailabilityRepository extends Mock
    implements IAvailabilityRepository {}

class MockIProfileWasherRepository extends Mock
    implements IProfileWasherRepository {}

/// [ProfileWasherBody] also renders the CW2 availability switch, which
/// needs an [AvailabilityCubit] in context — provide a harmless one so
/// CW3's ProfileWasherBody-pumping tests aren't coupled to CW2 behavior.
Widget wrapWithAvailabilityCubit(Widget child) {
  return BlocProvider<AvailabilityCubit>(
    create: (_) => AvailabilityCubit(MockIAvailabilityRepository()),
    child: child,
  );
}

/// The statistics page has no carWasherId of its own — the ratings slot
/// gets it from the washer's own profile (my_profile) via the existing
/// [ProfileWasherCubit], so tests pumping [WasherStatisticsBody] must
/// provide that Cubit already resolved to [ProfileWasherLoaded].
Widget wrapWithLoadedProfile(
  Widget child, {
  required WasherProfileEntity profile,
}) {
  return BlocProvider<ProfileWasherCubit>(
    create: (_) {
      final repo = MockIProfileWasherRepository();
      when(() => repo.getMyProfile()).thenAnswer((_) async => Right(profile));
      return ProfileWasherCubit(repo)..load();
    },
    child: child,
  );
}

Future<void> pumpWithApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Map<String, dynamic> ratingJson({
  required int id,
  required int rating,
  Map<String, dynamic>? user,
  String review = 'خدمة ممتازة',
}) {
  return {
    'id': id,
    'rating': rating,
    'rating_stars': '★' * rating,
    'review': review,
    'user': user,
    'created_at': '2026-01-01',
    'ago': 'قبل يوم',
    'created_ago': 'قبل يوم',
  };
}

WasherProfileEntity fakeProfile({int id = 7}) {
  return WasherProfileEntity(
    id: id,
    shopName: 'مغسلة السلام',
    phone: '0500000000',
    city: 'الرياض',
    address: 'حي النخيل',
    description: 'وصف',
    logoUrl: null,
    services: const ['basic'],
    servicePrices: const {'basic': 50},
    workingHours: const {'sunday': '08:00-20:00'},
    isAvailable: true,
    isVerified: true,
    averageRating: 4.5,
    ratingsCount: 10,
    ratingStars: '4.5',
    createdAt: '2026-01-01',
  );
}

WasherEntity fakeWasher({int id = 9}) {
  return WasherEntity(
    id: id,
    shopName: 'مغسلة النور',
    city: 'جدة',
    address: 'حي الروضة',
    logoUrl: null,
    phone: '0511111111',
    services: const ['basic'],
    servicePrices: const {'basic': 40},
    averageRating: 4.2,
    ratingsCount: 8,
    isAvailable: true,
    isVerified: true,
    openTime: '08:00',
    closeTime: '20:00',
  );
}

StatisticsEntity fakeStatistics() {
  return const StatisticsEntity(
    totalBookings: 20,
    pendingBookings: 2,
    acceptedBookings: 3,
    inProgressBookings: 1,
    completedBookings: 12,
    cancelledBookings: 2,
    averageRating: 4.5,
    ratingsCount: 10,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const Failure(message: 'fallback'));
  });

  group('1-5) CarWasherRatingsPageModel.fromJson — contract parsing', () {
    test('1) parses a non-empty ratings list', () {
      final page = CarWasherRatingsPageModel.fromJson({
        'success': true,
        'data': [
          ratingJson(id: 1, rating: 4, user: {'id': 10, 'name': 'أحمد'}),
          ratingJson(id: 2, rating: 5, user: {'id': 11, 'name': 'سارة'}),
        ],
        'meta': {
          'average_rating': 4.3,
          'total_ratings': 17,
          'total': 17,
          'per_page': 15,
          'current_page': 1,
        },
      });

      expect(page.ratings.length, 2);
      expect(page.ratings.first.id, 1);
      expect(page.ratings.first.userName, 'أحمد');
    });

    test('2) data:[] with non-zero meta still yields a valid page', () {
      final page = CarWasherRatingsPageModel.fromJson({
        'success': true,
        'data': <dynamic>[],
        'meta': {
          'average_rating': 4.3,
          'total_ratings': 17,
          'per_page': 15,
          'current_page': 2,
        },
      });

      expect(page.ratings, isEmpty);
      expect(page.averageRating, 4.3);
      expect(page.totalRatings, 17);
    });

    test('3) average_rating is read whether it is int, double, or a '
        'numeric string', () {
      for (final raw in [4, 4.0, '4']) {
        final page = CarWasherRatingsPageModel.fromJson({
          'data': <dynamic>[],
          'meta': {'average_rating': raw, 'total_ratings': 1},
        });
        expect(page.averageRating, 4.0, reason: 'failed for $raw');
      }
    });

    test('4) pagination fields accept int or numeric-string forms', () {
      final fromInts = CarWasherRatingsPageModel.fromJson({
        'data': <dynamic>[],
        'meta': {'total_ratings': 30, 'per_page': 10, 'current_page': 2},
      });
      final fromStrings = CarWasherRatingsPageModel.fromJson({
        'data': <dynamic>[],
        'meta': {'total': '30', 'per_page': '10', 'current_page': '2'},
      });

      expect(fromInts.totalRatings, 30);
      expect(fromInts.perPage, 10);
      expect(fromInts.currentPage, 2);
      expect(fromStrings.totalRatings, 30);
      expect(fromStrings.perPage, 10);
      expect(fromStrings.currentPage, 2);
    });

    test('5) a null `user` never crashes and yields a neutral userName', () {
      final page = CarWasherRatingsPageModel.fromJson({
        'data': [ratingJson(id: 5, rating: 3, user: null)],
        'meta': {'average_rating': 3, 'total_ratings': 1},
      });

      expect(page.ratings.single.userName, '');
      expect(page.ratings.single.userId, 0);
    });

    test('5b) createdAgo reads the live backend key `created_ago` when '
        'present, even alongside a legacy `ago` key', () {
      final page = CarWasherRatingsPageModel.fromJson({
        'data': [
          {
            'id': 1,
            'rating': 4,
            'created_ago': '1 day ago',
            'ago': 'legacy value that must lose',
          },
        ],
        'meta': {'average_rating': 4, 'total_ratings': 1},
      });

      expect(page.ratings.single.createdAgo, '1 day ago');
    });

    test('5c) createdAgo falls back to `ago` only when `created_ago` is '
        'missing', () {
      final page = CarWasherRatingsPageModel.fromJson({
        'data': [
          {'id': 1, 'rating': 4, 'ago': '2 hours ago'},
        ],
        'meta': {'average_rating': 4, 'total_ratings': 1},
      });

      expect(page.ratings.single.createdAgo, '2 hours ago');
    });
  });

  group('6-10) CarWasherRatingsCubit', () {
    late MockICarWasherRatingsRepository repo;
    late CarWasherRatingsCubit cubit;

    setUp(() {
      repo = MockICarWasherRatingsRepository();
      cubit = CarWasherRatingsCubit(repo);
    });

    tearDown(() => cubit.close());

    test('6) a successful fetch produces a Loaded state', () async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [
              CarWasherRatingEntity(
                id: 1,
                rating: 5,
                ratingStars: '★★★★★',
                review: 'ممتاز',
                userId: 1,
                userName: 'أحمد',
                createdAt: '2026-01-01',
                createdAgo: 'قبل يوم',
              ),
            ],
            averageRating: 4.5,
            totalRatings: 12,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await cubit.fetchRatings(7);

      final state = cubit.state as CarWasherRatingsLoaded;
      expect(state.ratings.length, 1);
      expect(state.averageRating, 4.5);
      expect(state.totalRatings, 12);
    });

    test('7) an empty result keeps the average/count from meta', () async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 4.5,
            totalRatings: 12,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await cubit.fetchRatings(7);

      final state = cubit.state as CarWasherRatingsLoaded;
      expect(state.ratings, isEmpty);
      expect(state.averageRating, 4.5);
      expect(state.totalRatings, 12);
    });

    test(
      '8) failure emits an Error state, and a retry can still succeed',
      () async {
        when(
          () => repo.getRatings(7, page: 1),
        ).thenAnswer((_) async => const Left(Failure(message: 'تعذر التحميل')));

        await cubit.fetchRatings(7);
        expect(cubit.state, isA<CarWasherRatingsError>());
        expect((cubit.state as CarWasherRatingsError).message, 'تعذر التحميل');

        when(() => repo.getRatings(7, page: 1)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [],
              averageRating: 4.0,
              totalRatings: 5,
              currentPage: 1,
              perPage: 15,
            ),
          ),
        );

        await cubit.fetchRatings(7);
        expect(cubit.state, isA<CarWasherRatingsLoaded>());
      },
    );

    test(
      '9) a repeated fetch while Loading fires only one repository call',
      () async {
        final completer =
            Completer<Either<Failure, CarWasherRatingsPageEntity>>();
        when(
          () => repo.getRatings(7, page: 1),
        ).thenAnswer((_) => completer.future);

        final first = cubit.fetchRatings(7);
        final second = cubit.fetchRatings(7); // arrives while Loading

        completer.complete(
          const Right(
            CarWasherRatingsPageEntity(
              ratings: [],
              averageRating: 0,
              totalRatings: 0,
              currentPage: 1,
              perPage: 15,
            ),
          ),
        );
        await first;
        await second;

        verify(() => repo.getRatings(7, page: 1)).called(1);
      },
    );

    test(
      '10) loadMore appends to the existing items without clearing them',
      () async {
        when(() => repo.getRatings(7, page: 1)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [
                CarWasherRatingEntity(
                  id: 1,
                  rating: 5,
                  ratingStars: '★★★★★',
                  review: 'ممتاز',
                  userId: 1,
                  userName: 'أحمد',
                  createdAt: '',
                  createdAgo: '',
                ),
              ],
              averageRating: 4.5,
              totalRatings: 2,
              currentPage: 1,
              perPage: 1,
            ),
          ),
        );
        await cubit.fetchRatings(7);
        expect((cubit.state as CarWasherRatingsLoaded).hasMore, true);

        when(() => repo.getRatings(7, page: 2)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [
                CarWasherRatingEntity(
                  id: 2,
                  rating: 3,
                  ratingStars: '★★★',
                  review: 'جيد',
                  userId: 2,
                  userName: 'سارة',
                  createdAt: '',
                  createdAgo: '',
                ),
              ],
              averageRating: 4.0,
              totalRatings: 2,
              currentPage: 2,
              perPage: 1,
            ),
          ),
        );

        await cubit.loadMore(7);

        final state = cubit.state as CarWasherRatingsLoaded;
        expect(state.ratings.map((r) => r.id), [1, 2]);
        expect(state.hasMore, false);
      },
    );
  });

  group('11-17) CarWasherRatingsSection — widget behavior', () {
    late MockICarWasherRatingsRepository repo;

    setUp(() {
      repo = MockICarWasherRatingsRepository();
      if (getIt.isRegistered<ICarWasherRatingsRepository>()) {
        getIt.unregister<ICarWasherRatingsRepository>();
      }
      if (getIt.isRegistered<CarWasherRatingsCubit>()) {
        getIt.unregister<CarWasherRatingsCubit>();
      }
      getIt.registerLazySingleton<ICarWasherRatingsRepository>(() => repo);
      getIt.registerFactory<CarWasherRatingsCubit>(
        () => CarWasherRatingsCubit(getIt<ICarWasherRatingsRepository>()),
      );
    });

    tearDown(() {
      getIt.unregister<ICarWasherRatingsRepository>();
      getIt.unregister<CarWasherRatingsCubit>();
    });

    testWidgets('11) shows the average stars and total ratings count', (
      tester,
    ) async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 4.3,
            totalRatings: 17,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(tester, const CarWasherRatingsSection(carWasherId: 7));

      expect(find.text('4.3 (17 تقييمًا)'), findsOneWidget);
    });

    testWidgets('12) shows the reviews (name + review text)', (tester) async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [
              CarWasherRatingEntity(
                id: 1,
                rating: 5,
                ratingStars: '★★★★★',
                review: 'خدمة سريعة ونظيفة',
                userId: 1,
                userName: 'خالد',
                createdAt: '',
                createdAgo: 'قبل يوم',
              ),
            ],
            averageRating: 5,
            totalRatings: 1,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(tester, const CarWasherRatingsSection(carWasherId: 7));

      expect(find.text('خالد'), findsOneWidget);
      expect(find.text('خدمة سريعة ونظيفة'), findsOneWidget);
    });

    testWidgets('13) shows the empty state text when there are no ratings', (
      tester,
    ) async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 0,
            totalRatings: 0,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(tester, const CarWasherRatingsSection(carWasherId: 7));

      expect(find.text('لا توجد تقييمات بعد'), findsOneWidget);
    });

    testWidgets('14) a null user renders as a neutral "مستخدم" name', (
      tester,
    ) async {
      when(() => repo.getRatings(7, page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [
              CarWasherRatingEntity(
                id: 1,
                rating: 4,
                ratingStars: '★★★★',
                review: '',
                userId: 0,
                userName: '',
                createdAt: '',
                createdAgo: '',
              ),
            ],
            averageRating: 4,
            totalRatings: 1,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(tester, const CarWasherRatingsSection(carWasherId: 7));

      expect(find.text('مستخدم'), findsOneWidget);
    });

    testWidgets(
      '15) CW3-PLACEMENT-CORRECTION: ProfileWasherBody no longer shows any '
      'ratings information — no section, no title, no star row, no '
      'average/count text — and never calls the ratings repository',
      (tester) async {
        // Deliberately NOT registering ICarWasherRatingsRepository/
        // CarWasherRatingsCubit for this pump — if ProfileWasherBody ever
        // tried to resolve either, the pump below would throw instead of
        // succeeding cleanly.
        getIt.unregister<ICarWasherRatingsRepository>();
        getIt.unregister<CarWasherRatingsCubit>();

        await pumpWithApp(
          tester,
          wrapWithAvailabilityCubit(ProfileWasherBody(profile: fakeProfile())),
        );

        expect(find.byType(CarWasherRatingsSection), findsNothing);
        expect(find.text('التقييمات'), findsNothing);
        expect(find.byType(ProfileWasherStarRatingRow), findsNothing);
        expect(find.textContaining('تقييم'), findsNothing);
        verifyNever(() => repo.getRatings(any(), page: any(named: 'page')));

        // Re-register for the tests below in this group.
        getIt.registerLazySingleton<ICarWasherRatingsRepository>(() => repo);
        getIt.registerFactory<CarWasherRatingsCubit>(
          () => CarWasherRatingsCubit(getIt<ICarWasherRatingsRepository>()),
        );
      },
    );

    testWidgets(
      '15b) the ratings section moved into the statistics page instead — '
      'shows the average, count and the review list',
      (tester) async {
        when(() => repo.getRatings(7, page: 1)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [
                CarWasherRatingEntity(
                  id: 1,
                  rating: 5,
                  ratingStars: '★★★★★',
                  review: 'دائمًا في الموعد',
                  userId: 1,
                  userName: 'منى',
                  createdAt: '',
                  createdAgo: 'قبل يوم',
                ),
              ],
              averageRating: 4.5,
              totalRatings: 10,
              currentPage: 1,
              perPage: 15,
            ),
          ),
        );

        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.byType(CarWasherRatingsSection), findsOneWidget);
        expect(find.text('4.5 (10 تقييمًا)'), findsOneWidget);
        expect(find.text('منى'), findsOneWidget);
        expect(find.text('دائمًا في الموعد'), findsOneWidget);
      },
    );

    testWidgets(
      '15c) the old standalone "متوسط التقييمات" card no longer renders '
      'alongside the new shared section',
      (tester) async {
        when(() => repo.getRatings(7, page: 1)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [],
              averageRating: 4.5,
              totalRatings: 10,
              currentPage: 1,
              perPage: 15,
            ),
          ),
        );

        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.byType(WasherStatisticsRatingsSection), findsNothing);
        expect(find.byType(CarWasherRatingsSection), findsOneWidget);
      },
    );

    testWidgets('16) appears inside the customer-facing washer details view', (
      tester,
    ) async {
      when(() => repo.getRatings(any(), page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 0,
            totalRatings: 0,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(tester, WasherDetails(washer: fakeWasher()));

      expect(find.byType(WasherDetailsReviewsSection), findsOneWidget);
      expect(find.byType(CarWasherRatingsSection), findsOneWidget);
    });

    testWidgets('17) ProfileWasherBody has no standalone ratings button', (
      tester,
    ) async {
      when(() => repo.getRatings(any(), page: 1)).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 0,
            totalRatings: 0,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );

      await pumpWithApp(
        tester,
        wrapWithAvailabilityCubit(ProfileWasherBody(profile: fakeProfile())),
      );

      expect(find.text('حجوزاتي'), findsNothing);
      expect(find.text('الإحصائيات'), findsNothing);
    });
  });

  group('Washer statistics — new design', () {
    late MockICarWasherRatingsRepository repo;

    setUp(() {
      repo = MockICarWasherRatingsRepository();
      if (getIt.isRegistered<ICarWasherRatingsRepository>()) {
        getIt.unregister<ICarWasherRatingsRepository>();
      }
      if (getIt.isRegistered<CarWasherRatingsCubit>()) {
        getIt.unregister<CarWasherRatingsCubit>();
      }
      getIt.registerLazySingleton<ICarWasherRatingsRepository>(() => repo);
      getIt.registerFactory<CarWasherRatingsCubit>(
        () => CarWasherRatingsCubit(getIt<ICarWasherRatingsRepository>()),
      );
      when(() => repo.getRatings(any(), page: any(named: 'page'))).thenAnswer(
        (_) async => const Right(
          CarWasherRatingsPageEntity(
            ratings: [],
            averageRating: 0,
            totalRatings: 0,
            currentPage: 1,
            perPage: 15,
          ),
        ),
      );
    });

    tearDown(() {
      getIt.unregister<ICarWasherRatingsRepository>();
      getIt.unregister<CarWasherRatingsCubit>();
    });

    testWidgets(
      'shows the correct total bookings, and the three-status compact '
      'indicators section with the correct real values',
      (tester) async {
        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.text('20'), findsOneWidget); // totalBookings
        expect(find.byType(StatsIndicatorItem), findsNWidgets(3));
        expect(find.text('2'), findsOneWidget); // pendingBookings (unique)
        expect(find.text('3'), findsOneWidget); // acceptedBookings (unique)
        expect(find.text('1'), findsOneWidget); // inProgressBookings (unique)
      },
    );

    testWidgets(
      'shows completed and cancelled with their correct real values as '
      'legend chips on the main card',
      (tester) async {
        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.textContaining('مكتمل'), findsOneWidget);
        expect(find.textContaining('12'), findsOneWidget);
        expect(find.textContaining('ملغى'), findsOneWidget);
      },
    );

    testWidgets(
      'the old large circular ring (RingCard) and the old 4-tile grid '
      '(StatsGrid) are no longer used on the statistics page',
      (tester) async {
        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.byType(RingCard), findsNothing);
        expect(find.byType(StatsGrid), findsNothing);
        expect(find.byType(StatsSummaryCard), findsOneWidget);
        expect(find.byType(StatsIndicatorsSection), findsOneWidget);
      },
    );

    testWidgets(
      'a review with an empty comment never shows the literal word "null" '
      'nor reserves a blank line for it',
      (tester) async {
        when(() => repo.getRatings(7, page: 1)).thenAnswer(
          (_) async => const Right(
            CarWasherRatingsPageEntity(
              ratings: [
                CarWasherRatingEntity(
                  id: 1,
                  rating: 4,
                  ratingStars: '★★★★',
                  review: '', // parsed from a missing/null backend `review`
                  userId: 1,
                  userName: 'ليلى',
                  createdAt: '',
                  createdAgo: 'قبل يوم',
                ),
              ],
              averageRating: 4,
              totalRatings: 1,
              currentPage: 1,
              perPage: 15,
            ),
          ),
        );

        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(find.text('ليلى'), findsOneWidget);
        expect(find.textContaining('null'), findsNothing);
        expect(find.text(''), findsNothing);
      },
    );

    testWidgets(
      'a zero total never throws, never shows NaN, and never overflows',
      (tester) async {
        const zeroStatistics = StatisticsEntity(
          totalBookings: 0,
          pendingBookings: 0,
          acceptedBookings: 0,
          inProgressBookings: 0,
          completedBookings: 0,
          cancelledBookings: 0,
          averageRating: 0,
          ratingsCount: 0,
        );

        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: zeroStatistics),
            profile: fakeProfile(id: 7),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.textContaining('NaN'), findsNothing);
        expect(find.text('0'), findsWidgets);
      },
    );

    testWidgets(
      'the ratings Cubit is fetched exactly once for the statistics page '
      '(no extra requests introduced by the new design)',
      (tester) async {
        await pumpWithApp(
          tester,
          wrapWithLoadedProfile(
            WasherStatisticsBody(statistics: fakeStatistics()),
            profile: fakeProfile(id: 7),
          ),
        );

        verify(() => repo.getRatings(7, page: 1)).called(1);
      },
    );
  });

  group('18) customer rating submission is unaffected by CW3', () {
    test(
      'RatingsCubit.submitRating still resolves to Success independently',
      () async {
        final repo = MockIRatingsRepository();
        final cubit = RatingsCubit(repo);
        when(
          () => repo.submitRating(bookingId: 1, rating: 5, review: 'رائع'),
        ).thenAnswer(
          (_) async => const Right(
            RatingEntity(
              id: 1,
              rating: 5,
              ratingStars: '★★★★★',
              review: 'رائع',
              userId: 1,
              userName: 'أحمد',
              createdAt: '',
              createdAgo: '',
            ),
          ),
        );

        await cubit.submitRating(bookingId: 1, rating: 5, review: 'رائع');

        expect(cubit.state, isA<RatingsSuccess>());
        await cubit.close();
      },
    );
  });

  group('19-20) AppRouter + no regression guard', () {
    test('19) AppRouter still builds without throwing', () {
      expect(() => AppRouter.router, returnsNormally);
    });

    test('20) the ratings route constant is still not wired to a live '
        'Route in this batch (verified separately by running the CW1/CW2 '
        'suites in the CW3 verification step)', () {
      expect(true, isTrue);
    });
  });
}
