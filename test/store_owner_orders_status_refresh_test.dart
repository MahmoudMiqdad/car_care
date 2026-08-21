import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/entities/spare_order_track_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/domain/repositories/i_spare_order_track_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/delivery_tracking/presentation/cubit/customer_delivery_tracking/customer_delivery_tracking_state.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_my_orders_page.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/pages/customer_order_details_page.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/domain/repositories/i_owner_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_orders/owner_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/pages/owner_order_details_page.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/pages/owner_orders_page.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/order_status_badge.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerOrdersRepository extends Mock
    implements ICustomerOrdersRepository {}

class MockOwnerOrdersRepository extends Mock
    implements IOwnerOrdersRepository {}

class MockSpareOrderTrackRepository extends Mock
    implements ISpareOrderTrackRepository {}

ShopEntity _fakeShop() {
  return const ShopEntity(
    id: 1,
    name: 'متجر تجريبي',
    phone: null,
    city: null,
    isActive: true,
    owner: null,
    businessTypes: [],
    carBrands: [],
    partCategories: [],
    createdAt: null,
  );
}

OrderEntity _fakeOrder({
  int id = 1,
  String status = 'pending',
  bool canCancel = false,
}) {
  return OrderEntity(
    id: id,
    shop: _fakeShop(),
    items: const [],
    totalPrice: 100,
    status: status,
    statusText: status,
    deliveryAddressNote: null,
    customerLatitude: null,
    customerLongitude: null,
    createdAt: null,
    canCancel: canCancel,
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
}

void main() {
  group('orderStatusColor / OrderStatusBadge — موحّد ومستقل لـ rejected', () {
    testWidgets(
      'rejected لون مختلف عن accepted، لكن مطابق للون error مثل cancelled',
      (tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        );
        expect(
          orderStatusColor(ctx, 'rejected'),
          isNot(orderStatusColor(ctx, 'accepted')),
        );
        expect(
          orderStatusColor(ctx, 'rejected'),
          orderStatusColor(ctx, 'cancelled'),
        );
      },
    );
  });

  group('CustomerMyOrdersPage — فلتر الحالات', () {
    testWidgets('يضم «مرفوض» ضمن 8 خيارات (مع «الكل»)', (tester) async {
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

      expect(find.text('مرفوض'), findsOneWidget);
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('ملغي'), findsOneWidget);
    });
  });

  group('CustomerDeliveryTrackingCubit — إيقاف Polling عند rejected', () {
    test('rejected يوقف الاستطلاع كحالة نهائية', () async {
      final repo = MockSpareOrderTrackRepository();
      when(() => repo.trackOrder(1)).thenAnswer(
        (_) async => Right(
          SpareOrderTrackEntity(
            orderStatus: 'rejected',
            trackingPoints: const [],
          ),
        ),
      );

      final cubit = CustomerDeliveryTrackingCubit(repo);
      await cubit.loadTracking(1);

      expect(cubit.state, isA<CustomerDeliveryTrackingEnded>());
      expect((cubit.state as CustomerDeliveryTrackingEnded).status, 'rejected');

      await cubit.close();
      verify(() => repo.trackOrder(1)).called(1);
    });
  });

  Future<void> pumpRouter(WidgetTester tester, GoRouter router) async {
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp.router(
          routerConfig: router,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('تفاصيل طلب العميل — Refresh عند الرجوع فقط إذا تغيّر شيء فعليًا', () {
    GoRouter buildRouter() => GoRouter(
      initialLocation: Routes.customerOrders,
      routes: [
        GoRoute(
          path: Routes.customerOrders,
          builder: (_, _) => const CustomerMyOrdersPage(),
        ),
        GoRoute(
          path: '${Routes.customerOrderDetails}/:id',
          builder: (_, state) => CustomerOrderDetailsPage(
            orderId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    );

    testWidgets('فتح ورجوع دون إلغاء: صفر Refresh إضافي على القائمة', (
      tester,
    ) async {
      final ordersRepo = MockCustomerOrdersRepository();
      when(
        () => ordersRepo.getOrders(status: any(named: 'status')),
      ).thenAnswer((_) async => Right([_fakeOrder(id: 1)]));
      when(
        () => ordersRepo.getOrderDetails(1),
      ).thenAnswer((_) async => Right(_fakeOrder(id: 1)));

      if (getIt.isRegistered<CustomerOrdersCubit>()) {
        getIt.unregister<CustomerOrdersCubit>();
      }
      if (getIt.isRegistered<OrderDetailsCubit>()) {
        getIt.unregister<OrderDetailsCubit>();
      }
      getIt.registerFactory<CustomerOrdersCubit>(
        () => CustomerOrdersCubit(ordersRepo),
      );
      getIt.registerFactory<OrderDetailsCubit>(
        () => OrderDetailsCubit(ordersRepo),
      );
      addTearDown(() {
        if (getIt.isRegistered<CustomerOrdersCubit>()) {
          getIt.unregister<CustomerOrdersCubit>();
        }
        if (getIt.isRegistered<OrderDetailsCubit>()) {
          getIt.unregister<OrderDetailsCubit>();
        }
      });

      await pumpRouter(tester, buildRouter());
      expect(tester.takeException(), isNull, reason: 'after initial pump');
      verify(() => ordersRepo.getOrders(status: null)).called(1);

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull, reason: 'after opening details');
      expect(find.byType(CustomerOrderDetailsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull, reason: 'after tapping back');

      verifyNever(() => ordersRepo.getOrders(status: null));
    });
  });

  group('طلبات المالك — Refresh عند الرجوع فقط بعد Mutation ناجحة', () {
    GoRouter buildRouter() => GoRouter(
      initialLocation: Routes.ownerOrders,
      routes: [
        GoRoute(
          path: Routes.ownerOrders,
          builder: (_, _) => const OwnerOrdersPage(),
        ),
        GoRoute(
          path: '${Routes.ownerOrderDetails}/:id',
          builder: (_, state) => OwnerOrderDetailsPage(
            orderId: int.parse(state.pathParameters['id']!),
          ),
        ),
      ],
    );

    testWidgets('فتح ورجوع دون أي إجراء: صفر Refresh إضافي', (tester) async {
      final repo = MockOwnerOrdersRepository();
      when(
        () => repo.getOrders(),
      ).thenAnswer((_) async => Right([_fakeOrder(id: 5, status: 'pending')]));
      when(
        () => repo.getOrderDetails(5),
      ).thenAnswer((_) async => Right(_fakeOrder(id: 5, status: 'pending')));

      if (getIt.isRegistered<OwnerOrdersCubit>()) {
        getIt.unregister<OwnerOrdersCubit>();
      }
      if (getIt.isRegistered<OwnerOrderDetailsCubit>()) {
        getIt.unregister<OwnerOrderDetailsCubit>();
      }
      getIt.registerFactory<OwnerOrdersCubit>(() => OwnerOrdersCubit(repo));
      getIt.registerFactory<OwnerOrderDetailsCubit>(
        () => OwnerOrderDetailsCubit(repo),
      );
      addTearDown(() {
        if (getIt.isRegistered<OwnerOrdersCubit>()) {
          getIt.unregister<OwnerOrdersCubit>();
        }
        if (getIt.isRegistered<OwnerOrderDetailsCubit>()) {
          getIt.unregister<OwnerOrderDetailsCubit>();
        }
      });

      await pumpRouter(tester, buildRouter());
      verify(() => repo.getOrders()).called(1);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(find.byType(OwnerOrderDetailsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.pumpAndSettle();

      verifyNever(() => repo.getOrders());
    });

    testWidgets('قبول الطلب ثم الرجوع: Refresh مرة واحدة فقط', (tester) async {
      final repo = MockOwnerOrdersRepository();
      when(
        () => repo.getOrders(),
      ).thenAnswer((_) async => Right([_fakeOrder(id: 7, status: 'pending')]));
      when(
        () => repo.getOrderDetails(7),
      ).thenAnswer((_) async => Right(_fakeOrder(id: 7, status: 'pending')));
      when(
        () => repo.acceptOrder(7),
      ).thenAnswer((_) async => Right(_fakeOrder(id: 7, status: 'accepted')));

      if (getIt.isRegistered<OwnerOrdersCubit>()) {
        getIt.unregister<OwnerOrdersCubit>();
      }
      if (getIt.isRegistered<OwnerOrderDetailsCubit>()) {
        getIt.unregister<OwnerOrderDetailsCubit>();
      }
      getIt.registerFactory<OwnerOrdersCubit>(() => OwnerOrdersCubit(repo));
      getIt.registerFactory<OwnerOrderDetailsCubit>(
        () => OwnerOrderDetailsCubit(repo),
      );
      addTearDown(() {
        if (getIt.isRegistered<OwnerOrdersCubit>()) {
          getIt.unregister<OwnerOrdersCubit>();
        }
        if (getIt.isRegistered<OwnerOrderDetailsCubit>()) {
          getIt.unregister<OwnerOrderDetailsCubit>();
        }
      });

      await pumpRouter(tester, buildRouter());
      verify(() => repo.getOrders()).called(1);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('قبول'));
      await tester.pumpAndSettle();
      verify(() => repo.acceptOrder(7)).called(1);

      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.pumpAndSettle();

      verify(() => repo.getOrders()).called(1);
    });
  });
}
