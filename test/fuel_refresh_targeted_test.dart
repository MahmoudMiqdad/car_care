import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_available_orders_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_order_details_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_order_page.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_order_details_page.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_orders_list_page.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_sos_create_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockUserFuelRepository extends Mock implements IUserFuelRepository {}

class MockFuelProviderOrderRepository extends Mock
    implements IFuelProviderOrderRepository {}

UserFuelOrderEntity _fakeUserOrder({int id = 1, String status = 'pending'}) {
  return UserFuelOrderEntity(
    id: id,
    fuelType: '95',
    amount: 10,
    status: status,
    statusText: status,
    totalPrice: '25',
    canCancel: status == 'pending',
  );
}

FuelOrderEntity _fakeProviderOrder({int id = 1, String status = 'pending'}) {
  return FuelOrderEntity(
    id: id,
    fuelType: '95',
    amount: 10,
    status: status,
    statusText: status,
    totalPrice: '25',
  );
}

void _ignoreKnownAppBarOverflowInTests() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('A RenderFlex overflowed')) {
      return;
    }
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
  _ignoreKnownAppBarOverflowInTests();

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
  await tester.pumpAndSettle();
}

class _AutoPopPage extends StatefulWidget {
  const _AutoPopPage({this.result});
  final bool? result;

  @override
  State<_AutoPopPage> createState() => _AutoPopPageState();
}

class _AutoPopPageState extends State<_AutoPopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop(widget.result);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  group('FUEL-REFRESH 1) customer create-order — list refresh', () {
    testWidgets(
      'FAB push resolving true triggers exactly one extra getAllOrders() call',
      (tester) async {
        final repo = MockUserFuelRepository();
        when(
          () => repo.getAllOrders(),
        ).thenAnswer((_) async => Right([_fakeUserOrder()]));

        final router = GoRouter(
          initialLocation: Routes.fuelorderslist,
          routes: [
            GoRoute(
              path: Routes.fuelorderslist,
              builder: (context, state) => BlocProvider(
                create: (_) => UserFuelCubit(repo),
                child: const FuelOrdersListPage(),
              ),
            ),
            GoRoute(
              path: Routes.add_user_fuel,
              builder: (context, state) => const _AutoPopPage(result: true),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        verify(() => repo.getAllOrders()).called(1);

        await tester.tap(find.byType(FloatingAddButton));
        await tester.pumpAndSettle();

        verify(() => repo.getAllOrders()).called(1);
      },
    );

    testWidgets(
      'FAB push resolving to a non-true value triggers no extra refresh',
      (tester) async {
        final repo = MockUserFuelRepository();
        when(
          () => repo.getAllOrders(),
        ).thenAnswer((_) async => Right([_fakeUserOrder()]));

        final router = GoRouter(
          initialLocation: Routes.fuelorderslist,
          routes: [
            GoRoute(
              path: Routes.fuelorderslist,
              builder: (context, state) => BlocProvider(
                create: (_) => UserFuelCubit(repo),
                child: const FuelOrdersListPage(),
              ),
            ),
            GoRoute(
              path: Routes.add_user_fuel,
              builder: (context, state) => const _AutoPopPage(),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        verify(() => repo.getAllOrders()).called(1);

        await tester.tap(find.byType(FloatingAddButton));
        await tester.pumpAndSettle();

        verifyNever(() => repo.getAllOrders());
      },
    );
  });

  group('FUEL-REFRESH 2) customer cancel pending-order — list refresh', () {
    testWidgets(
      'card push resolving true triggers exactly one extra getAllOrders() '
      'call',
      (tester) async {
        final repo = MockUserFuelRepository();
        when(
          () => repo.getAllOrders(),
        ).thenAnswer((_) async => Right([_fakeUserOrder()]));

        final router = GoRouter(
          initialLocation: Routes.fuelorderslist,
          routes: [
            GoRoute(
              path: Routes.fuelorderslist,
              builder: (context, state) => BlocProvider(
                create: (_) => UserFuelCubit(repo),
                child: const FuelOrdersListPage(),
              ),
            ),
            GoRoute(
              path: Routes.fuel_order_details,
              builder: (context, state) => const _AutoPopPage(result: true),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        verify(() => repo.getAllOrders()).called(1);

        await tester.tap(find.text('عرض التفاصيل'));
        await tester.pumpAndSettle();

        verify(() => repo.getAllOrders()).called(1);
      },
    );

    testWidgets(
      'card push resolving to a non-true value (plain view, no cancel) '
      'triggers no extra refresh',
      (tester) async {
        final repo = MockUserFuelRepository();
        when(
          () => repo.getAllOrders(),
        ).thenAnswer((_) async => Right([_fakeUserOrder()]));

        final router = GoRouter(
          initialLocation: Routes.fuelorderslist,
          routes: [
            GoRoute(
              path: Routes.fuelorderslist,
              builder: (context, state) => BlocProvider(
                create: (_) => UserFuelCubit(repo),
                child: const FuelOrdersListPage(),
              ),
            ),
            GoRoute(
              path: Routes.fuel_order_details,
              builder: (context, state) => const _AutoPopPage(),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        verify(() => repo.getAllOrders()).called(1);

        await tester.tap(find.text('عرض التفاصيل'));
        await tester.pumpAndSettle();

        verifyNever(() => repo.getAllOrders());
      },
    );

    testWidgets(
      'FuelOrderDetailsPage pops with result:true when a cancel succeeds',
      (tester) async {
        final repo = MockUserFuelRepository();
        when(
          () => repo.cancelOrder(1, 'سبب الإلغاء'),
        ).thenAnswer((_) async => const Right(null));

        bool? poppedWith;

        final router = GoRouter(
          initialLocation: '/origin',
          routes: [
            GoRoute(
              path: '/origin',
              builder: (context, state) => _AwaitPushOriginPage(
                onPush: () async {
                  poppedWith = await context.push<bool>(
                    Routes.fuel_order_details,
                    extra: _fakeUserOrder(),
                  );
                },
              ),
            ),
            GoRoute(
              path: Routes.fuel_order_details,
              builder: (context, state) => BlocProvider(
                create: (_) => UserFuelCubit(repo),
                child: FuelOrderDetailsPage(
                  order: state.extra as UserFuelOrderEntity,
                ),
              ),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await tester
            .element(find.byType(FuelOrderDetailsPage))
            .read<UserFuelCubit>()
            .cancelOrder(1, 'سبب الإلغاء');
        await tester.pumpAndSettle();

        expect(poppedWith, isTrue);
      },
    );
  });

  group(
    'FUEL-REFRESH 3) customer create-order — details-then-back cascade',
    () {
      testWidgets(
        'UserFuelOrderCreated pushes details then pops the create page with '
        'true once details is left',
        (tester) async {
          final repo = MockUserFuelRepository();
          final cubit = UserFuelCubit(repo);
          bool? poppedWith;

          final router = GoRouter(
            initialLocation: '/origin',
            routes: [
              GoRoute(
                path: '/origin',
                builder: (context, state) => _AwaitPushOriginPage(
                  onPush: () async {
                    poppedWith = await context.push<bool>(Routes.add_user_fuel);
                  },
                ),
              ),
              GoRoute(
                path: Routes.add_user_fuel,
                builder: (context, state) => BlocProvider.value(
                  value: cubit,
                  child: const FuelSosCreatePage(),
                ),
              ),
              GoRoute(
                path: Routes.fuel_order_details,
                builder: (context, state) => const _AutoPopPage(result: true),
              ),
            ],
          );

          await _pumpRouter(tester, router);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          when(
            () => repo.addEmergencyOrder(any()),
          ).thenAnswer((_) async => Right(_fakeUserOrder()));
          await cubit.addEmergencyOrder(const {});
          await tester.pumpAndSettle();

          expect(poppedWith, isTrue);
        },
      );
    },
  );

  group(
    'FUEL-REFRESH 4) provider accept order — dual list, minimum requests',
    () {
      testWidgets(
        'accepting from Available immediately removes it there with exactly '
        'one extra getAvailableOrders() call, and never eagerly fetches '
        'My Orders',
        (tester) async {
          final repo = MockFuelProviderOrderRepository();
          when(
            () => repo.getavailableOrders(),
          ).thenAnswer((_) async => Right([_fakeProviderOrder()]));
          when(
            () => repo.getMyOrders(),
          ).thenAnswer((_) async => const Right([]));

          final cubit = FuelProviderOrderCubit(repo);

          final router = GoRouter(
            initialLocation: Routes.provider_order,
            routes: [
              GoRoute(
                path: Routes.provider_order,
                builder: (context, state) => BlocProvider.value(
                  value: cubit,
                  child: const ProviderAvailableOrdersPage(),
                ),
              ),
              GoRoute(
                name: 'providerOrderDetailsPage',
                path: '/provider_order_details/:id',
                builder: (context, state) => const _AutoPopPage(result: true),
              ),
            ],
          );

          await cubit.getAvailableOrders();
          await _pumpRouter(tester, router);
          verify(() => repo.getavailableOrders()).called(1);

          await tester.tap(find.text('عرض التفاصيل'));
          await tester.pumpAndSettle();

          verify(() => repo.getavailableOrders()).called(1);
          verifyNever(() => repo.getMyOrders());
        },
      );

      testWidgets(
        'viewing details without accepting triggers no extra request',
        (tester) async {
          final repo = MockFuelProviderOrderRepository();
          when(
            () => repo.getavailableOrders(),
          ).thenAnswer((_) async => Right([_fakeProviderOrder()]));

          final cubit = FuelProviderOrderCubit(repo);

          final router = GoRouter(
            initialLocation: Routes.provider_order,
            routes: [
              GoRoute(
                path: Routes.provider_order,
                builder: (context, state) => BlocProvider.value(
                  value: cubit,
                  child: const ProviderAvailableOrdersPage(),
                ),
              ),
              GoRoute(
                name: 'providerOrderDetailsPage',
                path: '/provider_order_details/:id',
                builder: (context, state) => const _AutoPopPage(),
              ),
            ],
          );

          await cubit.getAvailableOrders();
          await _pumpRouter(tester, router);
          verify(() => repo.getavailableOrders()).called(1);

          await tester.tap(find.text('عرض التفاصيل'));
          await tester.pumpAndSettle();

          verifyNever(() => repo.getavailableOrders());
        },
      );
    },
  );

  group('FUEL-REFRESH 5) provider accept — double-tap guard', () {
    testWidgets(
      'tapping "قبول الطلب" twice before a pump opens exactly one dialog',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(
          () => repo.getOrder(1),
        ).thenAnswer((_) async => Right(_fakeProviderOrder()));

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );

        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        final router = GoRouter(
          initialLocation: '/provider_order_details/1',
          routes: [
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.ensureVisible(find.text('قبول الطلب'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('قبول الطلب'));
        await tester.tap(find.text('قبول الطلب'));
        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      },
    );
  });

  group('FUEL-REFRESH 6) provider cancel (uncommitted diff) — still sound', () {
    testWidgets('validateFuelProviderCancellationReason enforces min:5, '
        'matching the confirmed POST .../cancel contract', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(validateFuelProviderCancellationReason(ctx, null), isNotNull);
      expect(validateFuelProviderCancellationReason(ctx, ''), isNotNull);
      expect(validateFuelProviderCancellationReason(ctx, 'قصير'), isNotNull);
      expect(
        validateFuelProviderCancellationReason(ctx, 'سبب كافٍ للإلغاء'),
        isNull,
      );
    });

    testWidgets(
      'cancelling an accepted order calls cancelOrder with the reason and '
      'returns to Routes.provider_order',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(() => repo.getOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'accepted')),
        );
        when(
          () => repo.cancelOrder(1, any(that: isNotEmpty)),
        ).thenAnswer((_) async => Right(_fakeProviderOrder(status: 'pending')));

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        final router = GoRouter(
          initialLocation: '/provider_order_details/1',
          routes: [
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
            GoRoute(
              path: Routes.provider_order,
              builder: (context, state) =>
                  const Scaffold(body: Text('BACK_ON_PROVIDER_ORDER')),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.ensureVisible(find.text('إلغاء الطلب'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('إلغاء الطلب'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'سبب إلغاء كافٍ');
        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();

        verify(() => repo.cancelOrder(1, 'سبب إلغاء كافٍ')).called(1);
        expect(find.text('BACK_ON_PROVIDER_ORDER'), findsOneWidget);
      },
    );
  });

  group('FUEL-REFRESH 7) provider My Orders — details refresh', () {
    testWidgets('viewing details and returning true triggers exactly one extra '
        'getMyOrders() call', (tester) async {
      final repo = MockFuelProviderOrderRepository();
      when(
        () => repo.getMyOrders(),
      ).thenAnswer((_) async => Right([_fakeProviderOrder()]));

      final cubit = FuelProviderOrderCubit(repo);

      final router = GoRouter(
        initialLocation: Routes.provider_order,
        routes: [
          GoRoute(
            path: Routes.provider_order,
            builder: (context, state) => BlocProvider.value(
              value: cubit,
              child: const ProviderOrderPage(),
            ),
          ),
          GoRoute(
            name: 'providerOrderDetailsPage',
            path: '/provider_order_details/:id',
            builder: (context, state) => const _AutoPopPage(result: true),
          ),
        ],
      );

      await cubit.getMyOrders();
      await _pumpRouter(tester, router);
      verify(() => repo.getMyOrders()).called(1);

      await tester.tap(find.text('عرض التفاصيل'));
      await tester.pumpAndSettle();

      verify(() => repo.getMyOrders()).called(1);
      verifyNever(() => repo.getavailableOrders());
    });

    testWidgets(
      'returning null (no change) triggers no extra getMyOrders() request',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(
          () => repo.getMyOrders(),
        ).thenAnswer((_) async => Right([_fakeProviderOrder()]));

        final cubit = FuelProviderOrderCubit(repo);

        final router = GoRouter(
          initialLocation: Routes.provider_order,
          routes: [
            GoRoute(
              path: Routes.provider_order,
              builder: (context, state) => BlocProvider.value(
                value: cubit,
                child: const ProviderOrderPage(),
              ),
            ),
            GoRoute(
              name: 'providerOrderDetailsPage',
              path: '/provider_order_details/:id',
              builder: (context, state) => const _AutoPopPage(),
            ),
          ],
        );

        await cubit.getMyOrders();
        await _pumpRouter(tester, router);
        verify(() => repo.getMyOrders()).called(1);

        await tester.tap(find.text('عرض التفاصيل'));
        await tester.pumpAndSettle();

        verifyNever(() => repo.getMyOrders());
      },
    );

    testWidgets(
      'a successful "بدء التنفيذ" followed by a manual back returns true',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(() => repo.getOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'accepted')),
        );
        when(() => repo.startOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'in_progress')),
        );

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        bool? poppedWith;

        final router = GoRouter(
          initialLocation: '/origin',
          routes: [
            GoRoute(
              path: '/origin',
              builder: (context, state) => _AwaitPushOriginPage(
                onPush: () async {
                  poppedWith = await context.push<bool>(
                    '/provider_order_details/1',
                  );
                },
              ),
            ),
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();

        expect(find.byType(ProviderOrderDetailsPage), findsOneWidget);
        expect(poppedWith, isNull);

        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle();

        expect(poppedWith, isTrue);
      },
    );

    testWidgets(
      'a successful "إكمال الطلب" auto-returns true without a manual back',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(() => repo.getOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'in_progress')),
        );
        when(() => repo.completeOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'completed')),
        );

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        bool? poppedWith;

        final router = GoRouter(
          initialLocation: '/origin',
          routes: [
            GoRoute(
              path: '/origin',
              builder: (context, state) => _AwaitPushOriginPage(
                onPush: () async {
                  poppedWith = await context.push<bool>(
                    '/provider_order_details/1',
                  );
                },
              ),
            ),
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();

        expect(poppedWith, isTrue);
      },
    );

    testWidgets(
      'a failed "بدء التنفيذ" never returns true — the user is still on the '
      'page and manual back reports no change',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(() => repo.getOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'accepted')),
        );
        when(
          () => repo.startOrder(1),
        ).thenAnswer((_) async => const Left(Failure(message: 'فشل الطلب')));

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        bool? poppedWith;

        final router = GoRouter(
          initialLocation: '/origin',
          routes: [
            GoRoute(
              path: '/origin',
              builder: (context, state) => _AwaitPushOriginPage(
                onPush: () async {
                  poppedWith = await context.push<bool>(
                    '/provider_order_details/1',
                  );
                },
              ),
            ),
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();

        expect(find.byType(ProviderOrderDetailsPage), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_ios));
        await tester.pumpAndSettle();

        expect(poppedWith, isNot(true));
      },
    );

    testWidgets(
      'starting then completing in the same visit still yields exactly one '
      'refresh signal on the way out',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();

        var getOrderCalls = 0;
        when(() => repo.getOrder(1)).thenAnswer((_) async {
          getOrderCalls++;
          return Right(
            _fakeProviderOrder(
              status: getOrderCalls == 1 ? 'accepted' : 'in_progress',
            ),
          );
        });
        when(() => repo.startOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'in_progress')),
        );
        when(() => repo.completeOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'completed')),
        );

        if (getIt.isRegistered<FuelProviderOrderCubit>()) {
          getIt.unregister<FuelProviderOrderCubit>();
        }
        getIt.registerFactory<FuelProviderOrderCubit>(
          () => FuelProviderOrderCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        final poppedValues = <bool?>[];

        final router = GoRouter(
          initialLocation: '/origin',
          routes: [
            GoRoute(
              path: '/origin',
              builder: (context, state) => _AwaitPushOriginPage(
                onPush: () async {
                  final result = await context.push<bool>(
                    '/provider_order_details/1',
                  );
                  poppedValues.add(result);
                },
              ),
            ),
            GoRoute(
              path: '/provider_order_details/1',
              builder: (context, state) =>
                  const ProviderOrderDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();

        expect(poppedValues, [true]);
      },
    );
  });
}

class _AwaitPushOriginPage extends StatefulWidget {
  const _AwaitPushOriginPage({required this.onPush});
  final Future<void> Function() onPush;

  @override
  State<_AwaitPushOriginPage> createState() => _AwaitPushOriginPageState();
}

class _AwaitPushOriginPageState extends State<_AwaitPushOriginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: widget.onPush, child: const Text('push')),
    );
  }
}
