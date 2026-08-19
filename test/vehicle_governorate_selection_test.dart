// اختبارات دفعة SELECTION-SHEET: الـ SharedSelectionBottomSheet العام وبلاطتي
// المركبة والمحافظة المشتركتين، وسلوك كل شاشة بعد الترحيل (اختيار المركبة في
// الصيانة/الطوارئ/الوقود/غسيل السيارات، واختيار المحافظة لدى مزود الوقود).
import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/selection/governorate_selection_tile.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/core/widgets/selection/vehicle_selection_tile.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_vehicle_picker_sheet.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/repositories/i_provider_profile_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_create_profile_page.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/pages/add_requests_page.dart';
import 'package:car_care/features/sos/domain/repositories/i_sos_repository.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/pages/create_sos_page.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_sos_create_page.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRepository extends Mock implements IVehicleRepository {}

class MockRequestsRepository extends Mock implements IRequestsRepository {}

class MockSosRepository extends Mock implements ISosRepository {}

class MockUserFuelRepository extends Mock implements IUserFuelRepository {}

class MockFuelProviderProfileRepository extends Mock
    implements IFuelProviderProfileRepository {}

/// `AddRequestsPage`'s photo/date sections overflow under the test
/// harness's fallback font metrics regardless of surface size — the same
/// documented, pre-existing test-environment artifact filtered out in
/// `fuel_refresh_targeted_test.dart`, unrelated to the vehicle-picker
/// behavior under test here.
void _ignoreKnownOverflowInTests() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('A RenderFlex overflowed')) {
      return;
    }
    original?.call(details);
  };
}

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

/// A physical surface matching the ScreenUtil design ratio, for full pages
/// (like `AddRequestsPage`) whose content overflows the default 800x600
/// test surface — the same technique used elsewhere in this test suite for
/// full-page pumps (see `fuel_refresh_targeted_test.dart`).
Future<void> _pumpFullPage(WidgetTester tester, Widget child) async {
  _ignoreKnownOverflowInTests();
  tester.view.physicalSize = const Size(1125, 2436);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await _pumpWithApp(tester, child);
}

VehicleEntity _fakeVehicle({
  required int id,
  String brand = 'Toyota',
  String model = 'Corolla',
  int year = 2020,
  String plateNumber = 'ABC-123',
  String? image,
}) {
  return VehicleEntity(
    id: id,
    brand: brand,
    model: model,
    year: year,
    plateNumber: plateNumber,
    currentKm: 1000,
    status: 'active',
    needsMaintenance: false,
    image: image,
  );
}

void main() {
  group('SharedSelectionBottomSheet<T> — generic behavior', () {
    testWidgets(
      'renders the title and every item, tapping one calls onSelected '
      'exactly once with that item and closes the sheet',
      (tester) async {
        String? received;
        var callCount = 0;

        await _pumpWithApp(
          tester,
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SharedSelectionBottomSheet.show<String>(
                context: context,
                title: 'اختر عنصرًا',
                items: const ['أ', 'ب', 'ج'],
                itemBuilder: (context, item) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(item),
                ),
                onSelected: (item) {
                  received = item;
                  callCount++;
                },
              ),
              child: const Text('open'),
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('اختر عنصرًا'), findsOneWidget);
        expect(find.text('أ'), findsOneWidget);
        expect(find.text('ب'), findsOneWidget);
        expect(find.text('ج'), findsOneWidget);

        await tester.tap(find.text('ب'));
        await tester.pumpAndSettle();

        expect(callCount, 1);
        expect(received, 'ب');
        // The sheet is dismissed after selection.
        expect(find.text('اختر عنصرًا'), findsNothing);
      },
    );

    testWidgets(
      'itemBuilder receives the caller-computed selected state per item',
      (tester) async {
        const selectedValue = 'ب';

        await _pumpWithApp(
          tester,
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SharedSelectionBottomSheet.show<String>(
                context: context,
                title: 'اختر',
                items: const ['أ', 'ب', 'ج'],
                itemBuilder: (context, item) => GovernorateSelectionTile(
                  label: item,
                  isSelected: item == selectedValue,
                ),
                onSelected: (_) {},
              ),
              child: const Text('open'),
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        // Exactly one check icon — only the row matching selectedValue.
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      },
    );

    testWidgets('shows the empty-state widget when items is empty', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => SharedSelectionBottomSheet.show<String>(
              context: context,
              title: 'فارغ',
              items: const [],
              itemBuilder: (context, item) => Text(item),
              onSelected: (_) {},
              emptyState: const Text('لا يوجد عناصر'),
            ),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('لا يوجد عناصر'), findsOneWidget);
    });
  });

  group('VehicleSelectionTile', () {
    testWidgets('shows a fallback car icon when there is no image', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        VehicleSelectionTile(
          vehicle: _fakeVehicle(id: 1),
          isSelected: false,
          showImage: true,
        ),
      );

      expect(find.byIcon(Icons.directions_car), findsOneWidget);
    });

    testWidgets('shows plate number only when showPlateNumber is true', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        VehicleSelectionTile(
          vehicle: _fakeVehicle(id: 1, plateNumber: 'XYZ-999'),
          isSelected: false,
          showPlateNumber: false,
        ),
      );
      expect(find.text('XYZ-999'), findsNothing);

      await _pumpWithApp(
        tester,
        VehicleSelectionTile(
          vehicle: _fakeVehicle(id: 1, plateNumber: 'XYZ-999'),
          isSelected: false,
          showPlateNumber: true,
        ),
      );
      expect(find.text('XYZ-999'), findsOneWidget);
    });

    testWidgets('shows the year merged into the name line when showYear is '
        'true, and a check icon only when selected', (tester) async {
      await _pumpWithApp(
        tester,
        VehicleSelectionTile(
          vehicle: _fakeVehicle(id: 1, brand: 'Kia', model: 'Rio', year: 2019),
          isSelected: true,
          showYear: true,
        ),
      );

      expect(find.text('Kia Rio 2019'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('shows no check icon when not selected', (tester) async {
      await _pumpWithApp(
        tester,
        VehicleSelectionTile(vehicle: _fakeVehicle(id: 1), isSelected: false),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    });
  });

  group('GovernorateSelectionTile', () {
    testWidgets('shows its label and a check icon only when selected', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        const GovernorateSelectionTile(label: 'دمشق', isSelected: false),
      );
      expect(find.text('دمشق'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

      await _pumpWithApp(
        tester,
        const GovernorateSelectionTile(label: 'دمشق', isSelected: true),
      );
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });
  });

  group('AddRequestsPage — vehicle preselection and picking', () {
    setUp(() {
      if (getIt.isRegistered<IVehicleRepository>()) {
        getIt.unregister<IVehicleRepository>();
      }
      if (getIt.isRegistered<VehicleCubit>()) {
        getIt.unregister<VehicleCubit>();
      }
      if (getIt.isRegistered<IRequestsRepository>()) {
        getIt.unregister<IRequestsRepository>();
      }
    });

    testWidgets(
      'preselects the vehicle matching the passed-in vehicleId once '
      'vehicles load, without opening the picker',
      (tester) async {
        final vehicleRepo = MockVehicleRepository();
        when(() => vehicleRepo.getAllVehicles()).thenAnswer(
          (_) async => Right([
            _fakeVehicle(id: 1, brand: 'Kia', model: 'Rio'),
            _fakeVehicle(id: 2, brand: 'Honda', model: 'Civic'),
          ]),
        );
        getIt.registerLazySingleton<IVehicleRepository>(() => vehicleRepo);
        getIt.registerFactory<VehicleCubit>(
          () => VehicleCubit(getIt<IVehicleRepository>()),
        );
        getIt.registerFactory<IRequestsRepository>(
          () => MockRequestsRepository(),
        );

        await _pumpFullPage(tester, const AddRequestsPage(vehicleId: '2'));

        expect(find.textContaining('Honda Civic'), findsOneWidget);
        expect(find.text('تغيير المركبة'), findsOneWidget);
      },
    );

    testWidgets('picking a different vehicle from the sheet updates the '
        'selection', (tester) async {
      final vehicleRepo = MockVehicleRepository();
      when(() => vehicleRepo.getAllVehicles()).thenAnswer(
        (_) async => Right([
          _fakeVehicle(id: 1, brand: 'Kia', model: 'Rio'),
          _fakeVehicle(id: 2, brand: 'Honda', model: 'Civic'),
        ]),
      );
      getIt.registerLazySingleton<IVehicleRepository>(() => vehicleRepo);
      getIt.registerFactory<VehicleCubit>(
        () => VehicleCubit(getIt<IVehicleRepository>()),
      );
      getIt.registerFactory<IRequestsRepository>(
        () => MockRequestsRepository(),
      );

      await _pumpFullPage(tester, const AddRequestsPage(vehicleId: ''));

      await tester.tap(find.text('اختر المركبة'));
      await tester.pumpAndSettle();

      expect(find.text('اختر مركبتك'), findsOneWidget);
      await tester.tap(find.textContaining('Kia Rio'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Kia Rio'), findsOneWidget);
      expect(find.text('تغيير المركبة'), findsOneWidget);
    });
  });

  group('CreateSosPage — vehicle selection', () {
    testWidgets(
      'opens the shared picker and reflects the picked vehicle',
      (tester) async {
        final vehicleRepo = MockVehicleRepository();
        when(() => vehicleRepo.getAllVehicles()).thenAnswer(
          (_) async => Right([_fakeVehicle(id: 1, brand: 'Kia', model: 'Rio')]),
        );
        final vehicleCubit = VehicleCubit(vehicleRepo)..getAllVehicles();
        final sosCubit = SosCubit(MockSosRepository());

        await _pumpWithApp(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<VehicleCubit>.value(value: vehicleCubit),
              BlocProvider<SosCubit>.value(value: sosCubit),
            ],
            child: const CreateSosPage(),
          ),
        );

        await tester.tap(find.byIcon(Icons.directions_car_outlined).first);
        await tester.pumpAndSettle();

        expect(find.text('اختر مركبتك'), findsOneWidget);
        await tester.tap(find.textContaining('Kia Rio'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Kia Rio'), findsOneWidget);

        await vehicleCubit.close();
        await sosCubit.close();
      },
    );
  });

  group('FuelSosCreatePage — vehicle selection', () {
    testWidgets(
      'opens the shared picker and reflects the picked vehicle',
      (tester) async {
        final vehicleRepo = MockVehicleRepository();
        when(() => vehicleRepo.getAllVehicles()).thenAnswer(
          (_) async =>
              Right([_fakeVehicle(id: 5, brand: 'Ford', model: 'Focus')]),
        );
        final vehicleCubit = VehicleCubit(vehicleRepo)..getAllVehicles();
        final userFuelCubit = UserFuelCubit(MockUserFuelRepository());

        await _pumpWithApp(
          tester,
          MultiBlocProvider(
            providers: [
              BlocProvider<VehicleCubit>.value(value: vehicleCubit),
              BlocProvider<UserFuelCubit>.value(value: userFuelCubit),
            ],
            child: const FuelSosCreatePage(),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('اختر المركبة').first);
        await tester.pumpAndSettle();

        expect(find.text('اختر مركبتك'), findsOneWidget);
        await tester.tap(find.textContaining('Ford Focus'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Ford Focus'), findsOneWidget);

        await vehicleCubit.close();
        await userFuelCubit.close();
      },
    );
  });

  group('showReservationVehiclePicker — Car Wash reference sheet', () {
    testWidgets(
      'keeps the "اختر مركبتك" title, teal selection styling, and calls '
      'onSelect with the tapped vehicle',
      (tester) async {
        VehicleEntity? picked;
        final vehicles = [
          _fakeVehicle(id: 1, brand: 'Kia', model: 'Rio'),
          _fakeVehicle(id: 2, brand: 'Honda', model: 'Civic'),
        ];

        await _pumpWithApp(
          tester,
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showReservationVehiclePicker(
                context: context,
                vehicles: vehicles,
                selectedVehicle: vehicles[0],
                onSelect: (v) => picked = v,
              ),
              child: const Text('open'),
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('اختر مركبتك'), findsOneWidget);
        // No plate number in this reference sheet (unlike the other three).
        expect(find.text(vehicles[0].plateNumber), findsNothing);
        // The preselected vehicle (id 1) shows the check icon.
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

        await tester.tap(find.textContaining('Honda Civic'));
        await tester.pumpAndSettle();

        expect(picked?.id, 2);
      },
    );
  });

  group('ProviderCreateProfilePage — governorate selection', () {
    testWidgets(
      'opens the shared picker with the canonical province list and '
      'reflects the picked governorate',
      (tester) async {
        final cubit = FuelProviderProfileCubit(
          MockFuelProviderProfileRepository(),
        );

        await _pumpWithApp(
          tester,
          BlocProvider<FuelProviderProfileCubit>.value(
            value: cubit,
            child: const ProviderCreateProfilePage(),
          ),
        );

        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // The field's own hint text happens to read "اختر المحافظة" too
        // (`providerEditProfileGovernorateHint`), so assert the sheet
        // opened via its actual list contents instead of the title text.
        // It's a scrollable list, not every governorate is built up front —
        // the first item (visible without scrolling) is enough to confirm
        // the canonical list backs it.
        expect(find.text(kCreateSosProvinceOptions.first), findsWidgets);
        expect(find.text('حلب'), findsOneWidget);

        await tester.tap(find.text('حلب'));
        await tester.pumpAndSettle();

        expect(find.text('حلب'), findsWidgets);

        await cubit.close();
      },
    );
  });
}
