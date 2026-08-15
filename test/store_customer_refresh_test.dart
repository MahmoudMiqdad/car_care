// يثبت أن Pull-to-Refresh يعمل فعليًا (سحب حقيقي، وليس فقط استدعاء
// onRefresh برمجيًا) في الشاشات الخمس، بما فيها حالة القائمة الفارغة/الأقصر
// من ارتفاع الشاشة، وأنه يستدعي دالة الجلب مرة واحدة بالضبط.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/entities/cart_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/pages/cart_page.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_my_orders_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/repositories/i_products_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/all_products/all_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/pages/all_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/repositories/i_shops_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_products/shop_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shops_list/shops_list_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shops_list_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShopsRepository extends Mock implements IShopsRepository {}

class MockProductsRepository extends Mock implements IProductsRepository {}

class MockCartRepository extends Mock implements ICartRepository {}

class MockCustomerOrdersRepository extends Mock
    implements ICustomerOrdersRepository {}

ShopEntity _fakeShop({int id = 1}) {
  return ShopEntity(
    id: id,
    name: 'متجر تجريبي',
    phone: null,
    city: null,
    isActive: true,
    owner: null,
    businessTypes: const [],
    carBrands: const [],
    partCategories: const [],
    createdAt: null,
  );
}

Future<void> pumpWithApp(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
  expect(tester.takeException(), isNull);
}

/// يسحب الـScrollable الموجود فعليًا داخل RefreshIndicator (لا أي Scrollable
/// أفقي آخر في نفس الصفحة، مثل شريط فلتر الحالات) بمسافة كافية لتفعيل
/// RefreshIndicator، ثم ينتظر اكتمال الرسوم المتحركة والـFuture.
Future<void> dragToRefresh(WidgetTester tester) async {
  final scrollable = find.descendant(
    of: find.byType(RefreshIndicator),
    matching: find.byType(Scrollable),
  );
  await tester.fling(scrollable.first, const Offset(0, 300), 1000);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  expect(tester.takeException(), isNull);
}

void main() {
  group('Pull-to-Refresh — قائمة فارغة (أقصر من الشاشة)', () {
    testWidgets('ShopsListPage: سحب فعلي يستدعي fetchShops مرة واحدة', (
      tester,
    ) async {
      final repo = MockShopsRepository();
      when(
        () => repo.getShops(city: any(named: 'city')),
      ).thenAnswer((_) async => const Right([]));

      if (getIt.isRegistered<ShopsListCubit>()) {
        getIt.unregister<ShopsListCubit>();
      }
      getIt.registerFactory<ShopsListCubit>(() => ShopsListCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<ShopsListCubit>()) {
          getIt.unregister<ShopsListCubit>();
        }
      });

      await pumpWithApp(tester, const ShopsListPage());
      verify(() => repo.getShops(city: null)).called(1);

      await dragToRefresh(tester);

      verify(() => repo.getShops(city: null)).called(1);
    });

    testWidgets('CartPage: سحب فعلي يستدعي fetchCart مرة واحدة', (
      tester,
    ) async {
      final repo = MockCartRepository();
      when(
        () => repo.getCart(),
      ).thenAnswer((_) async => const Right(CartEntity(items: [], total: 0)));

      if (getIt.isRegistered<CartCubit>()) {
        getIt.unregister<CartCubit>();
      }
      getIt.registerFactory<CartCubit>(() => CartCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<CartCubit>()) {
          getIt.unregister<CartCubit>();
        }
      });

      await pumpWithApp(tester, const CartPage());
      verify(() => repo.getCart()).called(1);

      await dragToRefresh(tester);

      verify(() => repo.getCart()).called(1);
    });

    testWidgets('CustomerMyOrdersPage: سحب فعلي يستدعي getOrders مرة واحدة', (
      tester,
    ) async {
      final repo = MockCustomerOrdersRepository();
      when(
        () => repo.getOrders(status: any(named: 'status')),
      ).thenAnswer((_) async => const Right([]));

      if (getIt.isRegistered<CustomerOrdersCubit>()) {
        getIt.unregister<CustomerOrdersCubit>();
      }
      getIt.registerFactory<CustomerOrdersCubit>(
        () => CustomerOrdersCubit(repo),
      );
      addTearDown(() {
        if (getIt.isRegistered<CustomerOrdersCubit>()) {
          getIt.unregister<CustomerOrdersCubit>();
        }
      });

      await pumpWithApp(tester, const CustomerMyOrdersPage());
      verify(() => repo.getOrders(status: null)).called(1);

      await dragToRefresh(tester);

      verify(() => repo.getOrders(status: null)).called(1);
    });

    testWidgets('AllProductsPage: سحب فعلي يستدعي getAllProducts مرة واحدة', (
      tester,
    ) async {
      final repo = MockProductsRepository();
      when(
        () => repo.getAllProducts(),
      ).thenAnswer((_) async => const Right([]));

      if (getIt.isRegistered<AllProductsCubit>()) {
        getIt.unregister<AllProductsCubit>();
      }
      getIt.registerFactory<AllProductsCubit>(() => AllProductsCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<AllProductsCubit>()) {
          getIt.unregister<AllProductsCubit>();
        }
      });

      await pumpWithApp(tester, const AllProductsPage());
      verify(() => repo.getAllProducts()).called(1);

      await dragToRefresh(tester);

      verify(() => repo.getAllProducts()).called(1);
    });

    testWidgets(
      'ShopProductsPage (Storefront): سحب فعلي يستدعي getShopProducts مرة واحدة',
      (tester) async {
        final repo = MockShopsRepository();
        when(
          () => repo.getShopProducts(1),
        ).thenAnswer((_) async => const Right([]));

        if (getIt.isRegistered<ShopProductsCubit>()) {
          getIt.unregister<ShopProductsCubit>();
        }
        getIt.registerFactory<ShopProductsCubit>(() => ShopProductsCubit(repo));
        addTearDown(() {
          if (getIt.isRegistered<ShopProductsCubit>()) {
            getIt.unregister<ShopProductsCubit>();
          }
        });

        await pumpWithApp(
          tester,
          ShopProductsPage(shopId: 1, initialShop: _fakeShop()),
        );
        verify(() => repo.getShopProducts(1)).called(1);

        await dragToRefresh(tester);

        verify(() => repo.getShopProducts(1)).called(1);
      },
    );
  });
}
