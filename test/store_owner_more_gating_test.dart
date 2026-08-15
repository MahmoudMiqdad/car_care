// يثبت أن صفحة More تعرض خيارات صاحب متجر قطع الغيار حسب حالة المتجر
// الفعلية فقط: لا يوجد متجر -> «فتح متجر قطع غيار» فقط. غير معتمد
// (pending/rejected/suspended/null) -> «ملف المتجر» فقط. معتمد -> الخيارات
// الأربعة كاملة. ويثبت عدم وجود صفحة Owner Hub منفصلة.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/domain/repositories/i_advertisement_repository.dart';
import 'package:car_care/features/advertisements/presentation/cubit/advertisement_cubit.dart';
import 'package:car_care/features/more/presentation/pages/more_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/domain/repositories/i_owner_profile_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/features/user_profile/data/model/profile_model.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockIAdvertisementRepository extends Mock
    implements IAdvertisementRepository {}

class MockIOwnerProfileRepository extends Mock
    implements IOwnerProfileRepository {}

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

ShopEntity _fakeShop({String? status}) {
  return ShopEntity(
    id: 1,
    name: 'متجر تجريبي',
    phone: '0999999999',
    city: 'دمشق',
    isActive: true,
    owner: null,
    businessTypes: const [],
    carBrands: const [],
    partCategories: const [],
    createdAt: null,
    status: status,
  );
}

void main() {
  late MockProfileRemoteDataSource profileDs;
  late MockIAdvertisementRepository adsRepo;
  late MockIOwnerProfileRepository ownerProfileRepo;

  setUpAll(() {
    registerFallbackValue(AdvertisementPlacement.general);
  });

  setUp(() {
    profileDs = MockProfileRemoteDataSource();
    adsRepo = MockIAdvertisementRepository();
    ownerProfileRepo = MockIOwnerProfileRepository();
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
    if (getIt.isRegistered<IOwnerProfileRepository>()) {
      getIt.unregister<IOwnerProfileRepository>();
    }
    getIt.registerLazySingleton<SecureStorage>(() => _InMemorySecureStorage());
    getIt.registerLazySingleton<ProfileRemoteDataSource>(() => profileDs);
    getIt.registerFactory<AdvertisementCubit>(
      () => AdvertisementCubit(adsRepo),
    );
    getIt.registerLazySingleton<IOwnerProfileRepository>(
      () => ownerProfileRepo,
    );
    getIt.registerFactory<OwnerProfileCubit>(
      () => OwnerProfileCubit(ownerProfileRepo),
    );
  });

  tearDown(() {
    getIt.unregister<SecureStorage>();
    getIt.unregister<ProfileRemoteDataSource>();
    getIt.unregister<AdvertisementCubit>();
    getIt.unregister<IOwnerProfileRepository>();
    getIt.unregister<OwnerProfileCubit>();
  });

  Future<void> pumpMore(WidgetTester tester) async {
    when(() => profileDs.showprofile()).thenAnswer(
      (_) async =>
          ProfileModel(success: true, data: Data(roles: ['shop-owner'])),
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

  group('More — صاحب متجر معتمد (approved)', () {
    testWidgets('يعرض الخيارات الأربعة مباشرة، دون Owner Hub', (tester) async {
      when(
        () => ownerProfileRepo.getProfile(),
      ).thenAnswer((_) async => Right(_fakeShop(status: 'approved')));

      await pumpMore(tester);

      expect(find.text('ملف المتجر'), findsOneWidget);
      expect(find.text('طلبات المتجر'), findsOneWidget);
      expect(find.text('منتجات المتجر'), findsOneWidget);
      expect(find.text('تخصصات المتجر'), findsOneWidget);
      // لا وجود لعنوان Hub موحّد
      expect(find.text('إدارة المتجر'), findsNothing);
    });
  });

  group('More — صاحب متجر غير معتمد', () {
    testWidgets('pending: يظهر «ملف المتجر» فقط دون بقية الخيارات', (
      tester,
    ) async {
      when(
        () => ownerProfileRepo.getProfile(),
      ).thenAnswer((_) async => Right(_fakeShop(status: 'pending')));

      await pumpMore(tester);

      expect(find.text('ملف المتجر'), findsOneWidget);
      expect(find.text('طلبات المتجر'), findsNothing);
      expect(find.text('منتجات المتجر'), findsNothing);
      expect(find.text('تخصصات المتجر'), findsNothing);
    });

    testWidgets('حالة null لا تُعامل كـ approved', (tester) async {
      when(
        () => ownerProfileRepo.getProfile(),
      ).thenAnswer((_) async => Right(_fakeShop(status: null)));

      await pumpMore(tester);

      expect(find.text('ملف المتجر'), findsOneWidget);
      expect(find.text('طلبات المتجر'), findsNothing);
      expect(find.text('منتجات المتجر'), findsNothing);
      expect(find.text('تخصصات المتجر'), findsNothing);
    });
  });

  group('More — لا يوجد متجر بعد', () {
    testWidgets('يظهر «فتح متجر قطع غيار» فقط', (tester) async {
      when(() => ownerProfileRepo.getProfile()).thenAnswer(
        (_) async => const Left(Failure(message: 'لا يوجد متجر لهذا المستخدم')),
      );

      await pumpMore(tester);

      expect(find.text('فتح متجر قطع غيار'), findsOneWidget);
      expect(find.text('ملف المتجر'), findsNothing);
      expect(find.text('طلبات المتجر'), findsNothing);
    });
  });

  group('Routes — لا يوجد Route لـ Owner Hub', () {
    test('روابط المتجر مباشرة فقط (ملف/طلبات/منتجات/تخصصات)', () {
      expect(Routes.ownerProfile, '/spare-parts/owner/profile');
      expect(Routes.ownerOrders, '/spare-parts/owner/orders');
      expect(Routes.ownerProducts, '/spare-parts/owner/products');
      expect(Routes.ownerSpecializations, '/spare-parts/owner/specializations');
    });
  });
}
