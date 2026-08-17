// اختبارات Final Small UX Hardening: فشل start/complete/cancel لطلب وقود
// (بعد تحميل التفاصيل) يجب ألا يفرّغ الصفحة — يبقى ProviderOrderDetailsBody
// ظاهراً مع Snackbar فقط، بنفس مبدأ فشل الـ accept.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/entities/provider_order_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_order_details_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_order_details_body.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockFuelProviderOrderRepository extends Mock
    implements IFuelProviderOrderRepository {}

FuelOrderEntity _fakeProviderOrder({int id = 1, String status = 'accepted'}) {
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

void _registerCubit(MockFuelProviderOrderRepository repo) {
  if (getIt.isRegistered<FuelProviderOrderCubit>()) {
    getIt.unregister<FuelProviderOrderCubit>();
  }
  getIt.registerFactory<FuelProviderOrderCubit>(
    () => FuelProviderOrderCubit(repo),
  );
}

GoRouter _detailsRouter() => GoRouter(
  initialLocation: '/provider_order_details/1',
  routes: [
    GoRoute(
      path: '/provider_order_details/1',
      builder: (context, state) => const ProviderOrderDetailsPage(id: 1),
    ),
  ],
);

void main() {
  group('Fuel provider start/complete/cancel action-error hardening', () {
    testWidgets(
      'a failed "بدء التنفيذ" keeps the order details on screen (no blank '
      'SizedBox) and shows a snackbar',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(
          () => repo.getOrder(1),
        ).thenAnswer((_) async => Right(_fakeProviderOrder(status: 'accepted')));
        when(() => repo.startOrder(1)).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل بدء التنفيذ')),
        );

        _registerCubit(repo);
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        await _pumpRouter(tester, _detailsRouter());
        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);

        await tester.ensureVisible(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();

        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);
        expect(find.text('فشل بدء التنفيذ'), findsOneWidget);
      },
    );

    testWidgets(
      'a failed "إكمال الطلب" keeps the order details on screen and shows a '
      'snackbar',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(() => repo.getOrder(1)).thenAnswer(
          (_) async => Right(_fakeProviderOrder(status: 'in_progress')),
        );
        when(() => repo.completeOrder(1)).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل إكمال الطلب')),
        );

        _registerCubit(repo);
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        await _pumpRouter(tester, _detailsRouter());
        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);

        await tester.ensureVisible(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('إكمال الطلب'));
        await tester.pumpAndSettle();

        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);
        expect(find.text('فشل إكمال الطلب'), findsOneWidget);
      },
    );

    testWidgets(
      'a failed cancel keeps the order details on screen and shows a '
      'snackbar',
      (tester) async {
        final repo = MockFuelProviderOrderRepository();
        when(
          () => repo.getOrder(1),
        ).thenAnswer((_) async => Right(_fakeProviderOrder(status: 'accepted')));
        when(
          () => repo.cancelOrder(1, any(that: isNotEmpty)),
        ).thenAnswer((_) async => const Left(Failure(message: 'فشل الإلغاء')));

        _registerCubit(repo);
        addTearDown(() {
          if (getIt.isRegistered<FuelProviderOrderCubit>()) {
            getIt.unregister<FuelProviderOrderCubit>();
          }
        });

        await _pumpRouter(tester, _detailsRouter());
        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);

        await tester.ensureVisible(find.text('إلغاء الطلب'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('إلغاء الطلب'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'سبب إلغاء كافٍ');
        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();

        // Still on the details page with the same order visible — never
        // popped back on failure, unlike a successful cancel.
        expect(find.byType(ProviderOrderDetailsPage), findsOneWidget);
        expect(find.byType(ProviderOrderDetailsBody), findsOneWidget);
        expect(find.text('فشل الإلغاء'), findsOneWidget);
      },
    );
  });
}
