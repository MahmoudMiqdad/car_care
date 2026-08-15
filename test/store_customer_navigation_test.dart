// اختبارات تنقل أقسام متجر قطع الغيار الرئيسية: منع تكديس الجذور، وتمييز
// القسم الحالي، وغياب شريط التنقل من الشاشات الفرعية.
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/entities/cart_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/pages/cart_page.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_my_orders_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/repositories/i_products_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/all_products/all_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/pages/all_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shared/presentation/widgets/customer_store_bottom_nav_bar.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/repositories/i_shops_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shops_list/shops_list_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shops_list_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockShopsRepository extends Mock implements IShopsRepository {}

class MockProductsRepository extends Mock implements IProductsRepository {}

class MockCartRepository extends Mock implements ICartRepository {}

class MockCustomerOrdersRepository extends Mock
    implements ICustomerOrdersRepository {}

void main() {
  group('1) CustomerStoreSectionRoute — تطابق المسارات', () {
    test('كل قسم يقود إلى Route الجذر الصحيح', () {
      expect(CustomerStoreSection.shops.route, Routes.customerShopsList);
      expect(
        CustomerStoreSection.allProducts.route,
        Routes.customerAllProducts,
      );
      expect(CustomerStoreSection.cart.route, Routes.customerCart);
      expect(CustomerStoreSection.orders.route, Routes.customerOrders);
    });
  });

  group('2) شريط التنقل — التنقل بدون تكديس واختيار غير المكرر', () {
    GoRouter buildRouter() => GoRouter(
      initialLocation: Routes.customerShopsList,
      routes: [
        GoRoute(
          path: Routes.customerShopsList,
          builder: (_, _) => Scaffold(
            body: const Center(child: Text('SHOPS')),
            bottomNavigationBar: const CustomerStoreBottomNavBar(
              current: CustomerStoreSection.shops,
            ),
          ),
        ),
        GoRoute(
          path: Routes.customerAllProducts,
          builder: (_, _) => Scaffold(
            body: const Center(child: Text('ALL_PRODUCTS')),
            bottomNavigationBar: const CustomerStoreBottomNavBar(
              current: CustomerStoreSection.allProducts,
            ),
          ),
        ),
        GoRoute(
          path: Routes.customerCart,
          builder: (_, _) => Scaffold(
            body: const Center(child: Text('CART')),
            bottomNavigationBar: const CustomerStoreBottomNavBar(
              current: CustomerStoreSection.cart,
            ),
          ),
        ),
        GoRoute(
          path: Routes.customerOrders,
          builder: (_, _) => Scaffold(
            body: const Center(child: Text('ORDERS')),
            bottomNavigationBar: const CustomerStoreBottomNavBar(
              current: CustomerStoreSection.orders,
            ),
          ),
        ),
      ],
    );

    Future<void> pumpRouter(WidgetTester tester, GoRouter router) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'التنقل بين الأقسام الأربعة لا يزيد عدد الصفحات في المكدس أبدًا',
      (tester) async {
        final router = buildRouter();
        await pumpRouter(tester, router);

        void expectSingleMatch() {
          expect(router.routerDelegate.currentConfiguration.matches.length, 1);
        }

        expectSingleMatch();

        await tester.tap(find.text('كل المنتجات'));
        await tester.pumpAndSettle();
        expect(find.text('ALL_PRODUCTS'), findsOneWidget);
        expectSingleMatch();

        await tester.tap(find.text('السلة'));
        await tester.pumpAndSettle();
        expect(find.text('CART'), findsOneWidget);
        expectSingleMatch();

        await tester.tap(find.text('طلباتي'));
        await tester.pumpAndSettle();
        expect(find.text('ORDERS'), findsOneWidget);
        expectSingleMatch();

        await tester.tap(find.text('المتاجر'));
        await tester.pumpAndSettle();
        expect(find.text('SHOPS'), findsOneWidget);
        expectSingleMatch();
      },
    );

    testWidgets('النقر على القسم الحالي لا ينفّذ أي تنقل', (tester) async {
      final router = buildRouter();
      await pumpRouter(tester, router);

      final before = router.routerDelegate.currentConfiguration.uri.toString();
      await tester.tap(find.text('المتاجر'));
      await tester.pumpAndSettle();
      final after = router.routerDelegate.currentConfiguration.uri.toString();

      expect(after, before);
      expect(find.text('SHOPS'), findsOneWidget);
    });

    testWidgets('العنصر النشط في شريط التنقل يطابق القسم الحالي', (
      tester,
    ) async {
      final router = buildRouter();
      await pumpRouter(tester, router);

      BottomNavigationBar navBar() =>
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));

      expect(navBar().currentIndex, 0);

      await tester.tap(find.text('السلة'));
      await tester.pumpAndSettle();
      expect(navBar().currentIndex, 2);
    });
  });

  group('3) الشاشات الجذرية الفعلية تعرض شريط التنقل بالقسم الصحيح', () {
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
      // EmptyStateWidget animates forever، فلا نستخدم pumpAndSettle هنا.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }

    testWidgets('ShopsListPage تعرض CustomerStoreBottomNavBar بقسم shops', (
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

      final navBar = tester.widget<CustomerStoreBottomNavBar>(
        find.byType(CustomerStoreBottomNavBar),
      );
      expect(navBar.current, CustomerStoreSection.shops);
    });

    testWidgets(
      'AllProductsPage تعرض CustomerStoreBottomNavBar بقسم allProducts',
      (tester) async {
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

        final navBar = tester.widget<CustomerStoreBottomNavBar>(
          find.byType(CustomerStoreBottomNavBar),
        );
        expect(navBar.current, CustomerStoreSection.allProducts);
      },
    );

    testWidgets('CartPage تعرض CustomerStoreBottomNavBar بقسم cart', (
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

      final navBar = tester.widget<CustomerStoreBottomNavBar>(
        find.byType(CustomerStoreBottomNavBar),
      );
      expect(navBar.current, CustomerStoreSection.cart);
    });

    testWidgets(
      'CustomerMyOrdersPage تعرض CustomerStoreBottomNavBar بقسم orders',
      (tester) async {
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

        final navBar = tester.widget<CustomerStoreBottomNavBar>(
          find.byType(CustomerStoreBottomNavBar),
        );
        expect(navBar.current, CustomerStoreSection.orders);
      },
    );
  });
}
