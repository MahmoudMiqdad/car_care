// يثبت التعديلات المحدودة STORE-FLUTTER-UX-02:
// 1) ShopDetailsPage: لا تعرض اسم/هاتف/مدينة/مالك المتجر، فقط مجموعات التخصص الثلاث.
// 2) بطاقة المتجر في تفاصيل الطلب: تعرض اسم المتجر فقط دون مدينة/هاتف.
// 3) زر «تأكيد الموقع» يبقى أعلى Safe Area عند وجود Bottom Insets واقعية.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_item_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/widgets/checkout_location_picker_sheet.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_order_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_owner_summary_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/repositories/i_shops_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShopsRepository extends Mock implements IShopsRepository {}

class MockCustomerOrdersRepository extends Mock
    implements ICustomerOrdersRepository {}

final _fakeShop = ShopEntity(
  id: 1,
  name: 'متجر التيم ليدر',
  phone: '0984537172',
  city: 'دمشق',
  isActive: true,
  owner: const ShopOwnerSummaryEntity(
    id: 1,
    name: 'maya store',
    email: 'owner@example.com',
  ),
  businessTypes: const ['قطع غيار'],
  carBrands: const ['تويوتا'],
  partCategories: const ['محركات'],
  createdAt: DateTime(2024, 1, 1),
);

final _fakeOrder = OrderEntity(
  id: 55,
  shop: _fakeShop,
  items: [
    OrderItemEntity(
      id: 1,
      product: const ProductEntity(
        id: 1,
        name: 'قطعة تجريبية',
        description: '',
        price: 100,
        discountPrice: null,
        finalPrice: 100,
        stockQuantity: 10,
        weightKg: null,
        dimensions: null,
        isNew: true,
        isFeatured: false,
        carBrandName: null,
        partCategoryName: null,
        images: [],
        primaryImage: null,
        createdAt: null,
      ),
      quantity: 1,
      price: 100,
      subtotal: 100,
    ),
  ],
  totalPrice: 100,
  status: 'pending',
  statusText: 'قيد الانتظار',
  deliveryAddressNote: 'بصرى الشام - قرب الجامع',
  customerLatitude: 32.5198,
  customerLongitude: 36.4826,
  createdAt: DateTime(2024, 1, 1),
  canCancel: false,
);

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
  group('Fix 1: ShopDetailsPage — لا بيانات هوية/اتصال للمتجر', () {
    testWidgets('يعرض فقط مجموعات التخصص الثلاث ولا يعرض اسم/هاتف/مدينة/مالك', (
      tester,
    ) async {
      final repo = MockShopsRepository();
      when(
        () => repo.getShopDetails(1),
      ).thenAnswer((_) async => Right(_fakeShop));

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

      // مجموعات التخصص الثلاث موجودة
      expect(find.text('نوع النشاط'), findsOneWidget);
      expect(find.text('ماركات السيارات'), findsOneWidget);
      expect(find.text('فئات القطع'), findsOneWidget);

      // لا بيانات هوية/اتصال للمتجر
      expect(find.text(_fakeShop.name), findsNothing);
      expect(find.text(_fakeShop.phone!), findsNothing);
      expect(find.text(_fakeShop.city!), findsNothing);
      expect(find.text(_fakeShop.owner!.name!), findsNothing);
    });
  });

  group('Fix 3: بطاقة المتجر في تفاصيل الطلب — اسم المتجر فقط', () {
    testWidgets(
      'تعرض اسم المتجر فقط ولا تعرض مدينة/هاتف المتجر، وتُبقي قسم التوصيل',
      (tester) async {
        final repo = MockCustomerOrdersRepository();
        when(
          () => repo.getOrderDetails(55),
        ).thenAnswer((_) async => Right(_fakeOrder));

        if (getIt.isRegistered<OrderDetailsCubit>()) {
          getIt.unregister<OrderDetailsCubit>();
        }
        getIt.registerFactory<OrderDetailsCubit>(() => OrderDetailsCubit(repo));
        addTearDown(() {
          if (getIt.isRegistered<OrderDetailsCubit>()) {
            getIt.unregister<OrderDetailsCubit>();
          }
        });

        await pumpWithApp(tester, const CustomerOrderDetailsPage(orderId: 55));
        // إفراغ المؤقتات المؤجلة لتأثير الظهور التدريجي (staggered entrance)
        await tester.pump(const Duration(milliseconds: 500));

        // اسم المتجر ظاهر
        expect(find.text(_fakeShop.name), findsOneWidget);

        // لا مدينة ولا هاتف للمتجر داخل بطاقة المتجر
        expect(find.text(_fakeShop.city!), findsNothing);
        expect(find.text(_fakeShop.phone!), findsNothing);

        // قسم «التوصيل» يبقى سليمًا (العنوان/الإحداثيات لم تُحذف)
        expect(find.text('التوصيل'), findsOneWidget);
        expect(find.text(_fakeOrder.deliveryAddressNote!), findsOneWidget);
      },
    );
  });

  group('Fix 2: زر تأكيد الموقع يبقى أعلى Safe Area', () {
    testWidgets('لا يتداخل مع Bottom Insets واقعية (شريط تنقل الهاتف)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;
      // محاكاة شريط تنقل بالإيماءات (Gesture Navigation) بارتفاع واقعي
      const bottomInsetPhysical = 63.0; // ~21 منطقي * devicePixelRatio 3
      tester.view.viewPadding = const FakeViewPadding(
        bottom: bottomInsetPhysical,
      );
      tester.view.padding = const FakeViewPadding(bottom: bottomInsetPhysical);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewPadding);
      addTearDown(tester.view.resetPadding);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CheckoutLocationPickerSheet()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'تأكيد الموقع');
      expect(buttonFinder, findsOneWidget);

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final bottomInsetLogical =
          bottomInsetPhysical / tester.view.devicePixelRatio;

      final buttonBottom = tester.getBottomLeft(buttonFinder).dy;

      // يجب أن يبقى الزر أعلى منطقة الـSafe Area السفلية (لا يتداخل معها)
      expect(
        buttonBottom,
        lessThanOrEqualTo(screenHeight - bottomInsetLogical),
      );
    });
  });
}
