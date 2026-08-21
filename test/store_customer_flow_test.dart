import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/entities/cart_item_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_my_orders_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/repositories/i_products_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/product_details/product_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/pages/customer_product_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shared/presentation/widgets/customer_store_bottom_nav_bar.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/repositories/i_shops_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_products/shop_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_products_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/widgets/shops_governorate_filter.dart';
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

ProductEntity _fakeProduct({int id = 1, int stock = 5}) {
  return ProductEntity(
    id: id,
    name: 'فلتر زيت',
    description: 'وصف',
    price: 100,
    discountPrice: null,
    finalPrice: 100,
    stockQuantity: stock,
    weightKg: null,
    dimensions: null,
    isNew: true,
    isFeatured: false,
    carBrandName: null,
    partCategoryName: null,
    images: const [],
    primaryImage: null,
    createdAt: null,
  );
}

ShopEntity _fakeShop({int id = 1}) {
  return ShopEntity(
    id: id,
    name: 'متجر تجريبي',
    phone: '0999',
    city: 'دمشق',
    isActive: true,
    owner: null,
    businessTypes: const ['قطع محرك'],
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

void main() {
  group('1) شريط التنقل غائب عن الشاشات الفرعية', () {
    testWidgets('ShopDetailsPage لا تعرض CustomerStoreBottomNavBar', (
      tester,
    ) async {
      final repo = MockShopsRepository();
      when(
        () => repo.getShopDetails(1),
      ).thenAnswer((_) async => Right(_fakeShop()));

      if (getIt.isRegistered<ShopDetailsCubit>()) {
        getIt.unregister<ShopDetailsCubit>();
      }
      getIt.registerFactory<ShopDetailsCubit>(() => ShopDetailsCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<ShopDetailsCubit>()) {
          getIt.unregister<ShopDetailsCubit>();
        }
      });

      await pumpWithApp(tester, const ShopDetailsPage(shopId: 1));

      expect(find.byType(CustomerStoreBottomNavBar), findsNothing);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
      expect(find.text('عرض منتجات المتجر'), findsNothing);
    });

    testWidgets(
      'ShopProductsPage (Storefront) لا تعرض CustomerStoreBottomNavBar ولا أيقونة سلة',
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

        expect(find.byType(CustomerStoreBottomNavBar), findsNothing);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
        expect(find.text('معلومات المتجر'), findsOneWidget);
      },
    );
  });

  group('2) فلتر المحافظة — Request واحد فقط لكل اختيار', () {
    testWidgets('اختيار محافظة يستدعي onChanged مرة واحدة بالقيمة الصحيحة', (
      tester,
    ) async {
      String? received;
      var callCount = 0;

      await pumpWithApp(
        tester,
        Scaffold(
          body: ShopsGovernorateFilter(
            selectedGovernorate: null,
            onChanged: (value) {
              received = value;
              callCount++;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.text('دمشق').last);
      await tester.pumpAndSettle();

      expect(callCount, 1);
      expect(received, 'دمشق');
    });

    testWidgets('اختيار «كل المحافظات» يستدعي onChanged بقيمة null', (
      tester,
    ) async {
      String? received = 'دمشق';
      var callCount = 0;

      await pumpWithApp(
        tester,
        Scaffold(
          body: ShopsGovernorateFilter(
            selectedGovernorate: 'دمشق',
            onChanged: (value) {
              received = value;
              callCount++;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('كل المحافظات').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('كل المحافظات').last, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(callCount, 1);
      expect(received, isNull);
    });
  });

  group('3) طلباتي — الحالات السبع', () {
    testWidgets('تعرض فلاتر الحالات السبع الصحيحة', (tester) async {
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

      for (final label in [
        'الكل',
        'قيد الانتظار',
        'مقبول',
        'قيد التجهيز',
        'قيد التوصيل',
        'تم التسليم',
        'ملغي',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('اختيار حالة يستدعي getOrders بقيمة الحالة الصحيحة مرة واحدة', (
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

      await tester.ensureVisible(find.text('قيد التوصيل'));
      await tester.pump();
      await tester.tap(find.text('قيد التوصيل'), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      verify(() => repo.getOrders(status: 'out_for_delivery')).called(1);
    });
  });

  group('4) إضافة إلى السلة — Snackbar مع Action وبدون تكرار', () {
    testWidgets('النجاح يعرض Snackbar واحدة مع Action «عرض السلة»', (
      tester,
    ) async {
      final productsRepo = MockProductsRepository();
      when(
        () => productsRepo.getProductDetails(1),
      ).thenAnswer((_) async => Right(_fakeProduct()));

      final cartRepo = MockCartRepository();
      when(
        () => cartRepo.addToCart(
          productId: any(named: 'productId'),
          quantity: any(named: 'quantity'),
        ),
      ).thenAnswer(
        (_) async => Right(
          CartItemEntity(
            id: 1,
            product: _fakeProduct(),
            quantity: 1,
            subtotal: 100,
            addedAt: null,
          ),
        ),
      );

      if (getIt.isRegistered<ProductDetailsCubit>()) {
        getIt.unregister<ProductDetailsCubit>();
      }
      getIt.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(productsRepo),
      );
      if (getIt.isRegistered<AddToCartCubit>()) {
        getIt.unregister<AddToCartCubit>();
      }
      getIt.registerFactory<AddToCartCubit>(() => AddToCartCubit(cartRepo));
      addTearDown(() {
        if (getIt.isRegistered<ProductDetailsCubit>()) {
          getIt.unregister<ProductDetailsCubit>();
        }
        if (getIt.isRegistered<AddToCartCubit>()) {
          getIt.unregister<AddToCartCubit>();
        }
      });

      await pumpWithApp(tester, const CustomerProductDetailsPage(productId: 1));

      await tester.tap(find.text('أضف إلى السلة — 100 ل.س'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('تمت إضافة المنتج إلى السلة بنجاح'), findsOneWidget);
      expect(find.text('عرض السلة'), findsOneWidget);

      verify(() => cartRepo.addToCart(productId: 1, quantity: 1)).called(1);
    });

    testWidgets('الفشل لا يعرض Action النجاح', (tester) async {
      final productsRepo = MockProductsRepository();
      when(
        () => productsRepo.getProductDetails(1),
      ).thenAnswer((_) async => Right(_fakeProduct()));

      final cartRepo = MockCartRepository();
      when(
        () => cartRepo.addToCart(
          productId: any(named: 'productId'),
          quantity: any(named: 'quantity'),
        ),
      ).thenAnswer((_) async => const Left(Failure(message: 'فشل الإضافة')));

      if (getIt.isRegistered<ProductDetailsCubit>()) {
        getIt.unregister<ProductDetailsCubit>();
      }
      getIt.registerFactory<ProductDetailsCubit>(
        () => ProductDetailsCubit(productsRepo),
      );
      if (getIt.isRegistered<AddToCartCubit>()) {
        getIt.unregister<AddToCartCubit>();
      }
      getIt.registerFactory<AddToCartCubit>(() => AddToCartCubit(cartRepo));
      addTearDown(() {
        if (getIt.isRegistered<ProductDetailsCubit>()) {
          getIt.unregister<ProductDetailsCubit>();
        }
        if (getIt.isRegistered<AddToCartCubit>()) {
          getIt.unregister<AddToCartCubit>();
        }
      });

      await pumpWithApp(tester, const CustomerProductDetailsPage(productId: 1));

      await tester.tap(find.text('أضف إلى السلة — 100 ل.س'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('فشل الإضافة'), findsOneWidget);
      expect(find.text('عرض السلة'), findsNothing);
    });
  });
}
