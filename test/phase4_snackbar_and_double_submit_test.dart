import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/repositories/i_car_wash_booking_repository.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/reservation/car_wash_booking_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/domain/repositories/i_provider_order_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_available_orders_page.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/repositories/i_quotations_repository.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_cubit.dart';
import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_body.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_body.dart';
import 'package:car_care/features/vehicle/data/data_sources/vehicle_remote_data_source.dart';
import 'package:car_care/features/vehicle/data/repositories/vehicle_repos_impl.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSosRepository extends Mock implements ISosRepository {}

class MockUserFuelRepository extends Mock implements IUserFuelRepository {}

class MockQuotationsRepository extends Mock implements IQuotationsRepository {}

class MockCarWashBookingRepository extends Mock
    implements ICarWashBookingRepository {}

class MockFuelProviderOrderRepository extends Mock
    implements IFuelProviderOrderRepository {}

class MockApiService extends Mock implements ApiService {}

const _err = Failure(message: 'فشل الطلب');

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

void main() {
  group('SosCubit.createSos — reentry guard', () {
    test('two concurrent calls only hit the repository once', () async {
      final repo = MockSosRepository();
      var callCount = 0;
      when(() => repo.createSos(any())).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Left(_err);
      });
      final cubit = SosCubit(repo);

      final first = cubit.createSos(const {});
      final second = cubit.createSos(const {});
      await Future.wait([first, second]);

      expect(callCount, 1);
      await cubit.close();
    });
  });

  group('UserFuelCubit.addEmergencyOrder — reentry guard', () {
    test('two concurrent calls only hit the repository once', () async {
      final repo = MockUserFuelRepository();
      var callCount = 0;
      when(() => repo.addEmergencyOrder(any())).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Left(_err);
      });
      final cubit = UserFuelCubit(repo);

      final first = cubit.addEmergencyOrder(const {});
      final second = cubit.addEmergencyOrder(const {});
      await Future.wait([first, second]);

      expect(callCount, 1);
      await cubit.close();
    });
  });

  group('QuotationsCubit — accept/reject reentry guards', () {
    test('two concurrent acceptQuotation calls only hit the repository once', () async {
      final repo = MockQuotationsRepository();
      var callCount = 0;
      when(
        () => repo.acceptQuotation(any(), any(), any()),
      ).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Left(_err);
      });
      final cubit = QuotationsCubit(repo);

      final first = cubit.acceptQuotation(const {}, '1', '1');
      final second = cubit.acceptQuotation(const {}, '1', '1');
      await Future.wait([first, second]);

      expect(callCount, 1);
      await cubit.close();
    });

    test('two concurrent rejectQuotation calls only hit the repository once', () async {
      final repo = MockQuotationsRepository();
      var callCount = 0;
      when(() => repo.rejectQuotation(any(), any())).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Left(_err);
      });
      final cubit = QuotationsCubit(repo);

      final first = cubit.rejectQuotation('سبب', '1');
      final second = cubit.rejectQuotation('سبب', '1');
      await Future.wait([first, second]);

      expect(callCount, 1);
      await cubit.close();
    });
  });

  group('CarWashBookingCubit.createBooking — reentry guard', () {
    test('two concurrent calls only hit the repository once', () async {
      final repo = MockCarWashBookingRepository();
      var callCount = 0;
      when(
        () => repo.createBooking(
          vehicleId: any(named: 'vehicleId'),
          carWasherId: any(named: 'carWasherId'),
          scheduledAt: any(named: 'scheduledAt'),
          serviceType: any(named: 'serviceType'),
          notes: any(named: 'notes'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const Left(_err);
      });
      final cubit = CarWashBookingCubit(repo);

      final first = cubit.createBooking(
        vehicleId: 1,
        carWasherId: 1,
        scheduledAt: '2026-01-01 10:00:00',
        serviceType: 'basic',
      );
      final second = cubit.createBooking(
        vehicleId: 1,
        carWasherId: 1,
        scheduledAt: '2026-01-01 10:00:00',
        serviceType: 'basic',
      );
      await Future.wait([first, second]);

      expect(callCount, 1);
      await cubit.close();
    });
  });

  group('SelectTriggerField-backed submit buttons — disabled while loading', () {
    testWidgets('CreateSosBody disables submit and the vehicle/province rows '
        'when isLoading is true', (tester) async {
      var vehicleTapped = false;
      var submitTapped = false;

      await _pumpWithApp(
        tester,
        Directionality(
          textDirection: TextDirection.rtl,
          child: CreateSosBody(
            descriptionController: TextEditingController(),
            vehicleValue: 'Kia Rio',
            provinceValue: 'دمشق',
            onPickVehicle: () => vehicleTapped = true,
            onPickProvince: () {},
            onSubmit: () => submitTapped = true,
            isLoading: true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.directions_car_outlined));
      expect(vehicleTapped, isFalse);

      await tester.tap(find.textContaining('جاري الإرسال'));
      expect(submitTapped, isFalse);
    });

    testWidgets('FuelSosCreateBody submit button is disabled while isLoading '
        'and enabled again once isLoading is false', (tester) async {
      var submitCount = 0;

      await _pumpWithApp(
        tester,
        Directionality(
          textDirection: TextDirection.rtl,
          child: FuelSosCreateBody(
            vehicleValue: 'Kia Rio',
            fuelTypeValue: '95',
            provinceValue: 'دمشق',
            quantityController: TextEditingController(text: '10'),
            notesController: TextEditingController(),
            onPickVehicle: () {},
            onPickFuelType: () {},
            onPickProvince: () {},
            onSubmit: () => submitCount++,
            isLoading: true,
          ),
        ),
      );

      final loadingButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(loadingButton.onPressed, isNull);

      await _pumpWithApp(
        tester,
        Directionality(
          textDirection: TextDirection.rtl,
          child: FuelSosCreateBody(
            vehicleValue: 'Kia Rio',
            fuelTypeValue: '95',
            provinceValue: 'دمشق',
            quantityController: TextEditingController(text: '10'),
            notesController: TextEditingController(),
            onPickVehicle: () {},
            onPickFuelType: () {},
            onPickProvince: () {},
            onSubmit: () => submitCount++,
            isLoading: false,
          ),
        ),
      );

      final enabledButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(enabledButton.onPressed, isNotNull);

      enabledButton.onPressed!();
      expect(submitCount, 1);
    });
  });

  group('AppSnackBar', () {
    testWidgets('success shows a green snackbar with the check icon', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppSnackBar.success(context, 'تم بنجاح'),
            child: const Text('go'),
          ),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.green.shade600);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('تم بنجاح'), findsOneWidget);
    });

    testWidgets('error shows a red snackbar with the error icon', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppSnackBar.error(context, 'حدث خطأ'),
            child: const Text('go'),
          ),
        ),
      );

      await tester.tap(find.text('go'));
      await tester.pump();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, Colors.red.shade600);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('حدث خطأ'), findsOneWidget);
    });

    testWidgets('a second call replaces the first instead of stacking', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        Builder(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => AppSnackBar.error(context, 'أولاً'),
                child: const Text('first'),
              ),
              ElevatedButton(
                onPressed: () => AppSnackBar.success(context, 'ثانياً'),
                child: const Text('second'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('first'));
      await tester.pump();
      await tester.tap(find.text('second'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('ثانياً'), findsOneWidget);
    });
  });

  group(
    'ProviderAvailableOrdersPage — error feedback via listener, not build',
    () {
      testWidgets(
        'an unrelated rebuild while the error state is unchanged does not '
        'show a second snackbar',
        (tester) async {
          final repo = MockFuelProviderOrderRepository();
          when(
            () => repo.getavailableOrders(),
          ).thenAnswer((_) async => const Left(_err));
          final cubit = FuelProviderOrderCubit(repo);

          final rebuildNotifier = ValueNotifier(0);
          await tester.pumpWidget(
            ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, _) => MaterialApp(
                home: BlocProvider<FuelProviderOrderCubit>.value(
                  value: cubit,
                  child: ValueListenableBuilder<int>(
                    valueListenable: rebuildNotifier,
                    builder: (_, _, _) =>
                        const ProviderAvailableOrdersPage(),
                  ),
                ),
              ),
            ),
          );

          cubit.getAvailableOrders();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          expect(find.byType(SnackBar), findsOneWidget);

          rebuildNotifier.value++;
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          expect(find.byType(SnackBar), findsOneWidget);

          await cubit.close();
        },
      );
    },
  );

  group('VehicleRepositoryImpl.addVehicle — no raw exception leakage', () {
    test(
      'a client-side exception (missing image bytes/name) maps to the safe '
      'generic fallback, never the raw exception text',
      () async {
        final repo = VehicleRepositoryImpl(
          VehicleRemoteDataSource(MockApiService()),
        );

        final result = await repo.addVehicle(const {});

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure.message, 'حدث خطأ غير متوقع');
          expect(failure.message.contains('Exception'), isFalse);
          expect(failure.message.contains('Instance of'), isFalse);
        }, (_) => fail('expected a Left'));
      },
    );
  });
}
