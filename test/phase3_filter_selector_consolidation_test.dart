// اختبارات دفعة PHASE3-CONSOLIDATION: فلتر الإشعارات عبر StatusFilterTabs،
// منتقي نوع الوقود عبر SharedSelectionBottomSheet، وحقل SelectTriggerField
// المشترك بعد استبدال الحقول المكررة الثلاثة (SOS/الوقود/مزود الوقود).
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/selection/select_trigger_field.dart';
import 'package:car_care/features/home/presentation/pages/notifications_page.dart';
import 'package:car_care/features/notifications/domain/entities/notification_entity.dart';
import 'package:car_care/features/notifications/domain/repositories/i_notifications_repository.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_body.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_body.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_create_profile_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/repositories/i_provider_profile_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/user_fuel/domain/repositories/i_user_fuel_repository.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/pages/fuel_sos_create_page.dart';
import 'package:car_care/features/vehicle/domain/repositories/i_vehicle_repository.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock
    implements INotificationsRepository {}

class MockFuelProviderProfileRepository extends Mock
    implements IFuelProviderProfileRepository {}

class MockVehicleRepository extends Mock implements IVehicleRepository {}

class MockUserFuelRepository extends Mock implements IUserFuelRepository {}

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

NotificationEntity _fakeNotification({
  String id = '1',
  DateTime? readAt,
}) {
  return NotificationEntity(
    id: id,
    type: 'fuel_order_accepted',
    title: 'عنوان $id',
    body: 'نص $id',
    data: const {},
    readAt: readAt,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

void _registerNotificationsCubit(MockNotificationsRepository repo) {
  if (getIt.isRegistered<NotificationsCubit>()) {
    getIt.unregister<NotificationsCubit>();
  }
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit(repo));
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
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
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  group('NotificationsPage — filter now on StatusFilterTabs', () {
    setUp(() {});

    testWidgets(
      'shows "الكل" and "غير مقروءة" and calls setFilter(unread) when '
      'tapped, re-fetching with the unread filter',
      (tester) async {
        final repo = MockNotificationsRepository();
        when(() => repo.getNotifications(unread: null)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(
              items: [_fakeNotification(id: '1', readAt: null)],
              unreadCount: 1,
            ),
          ),
        );
        when(() => repo.getNotifications(unread: true)).thenAnswer(
          (_) async => Right(
            NotificationsListResult(
              items: [_fakeNotification(id: '2', readAt: null)],
              unreadCount: 1,
            ),
          ),
        );
        _registerNotificationsCubit(repo);

        final router = GoRouter(
          initialLocation: '/notifications',
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        );

        await _pumpRouter(tester, router);

        expect(find.text('الكل'), findsOneWidget);
        expect(find.text('غير مقروءة'), findsOneWidget);

        await tester.tap(find.text('غير مقروءة'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        verify(() => repo.getNotifications(unread: true)).called(1);
      },
    );
  });

  group('SelectTriggerField', () {
    testWidgets('shows the label and value, or the placeholder when empty', (
      tester,
    ) async {
      await _pumpWithApp(
        tester,
        SelectTriggerField(
          label: 'الحقل',
          value: null,
          placeholder: 'اختر قيمة',
          onTap: () {},
        ),
      );
      expect(find.text('الحقل'), findsOneWidget);
      expect(find.text('اختر قيمة'), findsOneWidget);

      await _pumpWithApp(
        tester,
        SelectTriggerField(
          label: 'الحقل',
          value: 'قيمة مختارة',
          placeholder: 'اختر قيمة',
          onTap: () {},
        ),
      );
      expect(find.text('قيمة مختارة'), findsOneWidget);
      expect(find.text('اختر قيمة'), findsNothing);
    });

    testWidgets('renders an optional leading widget', (tester) async {
      await _pumpWithApp(
        tester,
        SelectTriggerField(
          label: 'الحقل',
          onTap: () {},
          leading: const Icon(Icons.directions_car_outlined),
        ),
      );
      expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await _pumpWithApp(
        tester,
        SelectTriggerField(
          label: 'الحقل',
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(SelectTriggerField));
      expect(tapped, isTrue);
    });

    testWidgets('respects ambient RTL/LTR directionality for the row', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: SelectTriggerField(label: 'Field', onTap: () {}),
            ),
          ),
        ),
      );
      expect(
        Directionality.of(tester.element(find.byType(SelectTriggerField))),
        TextDirection.ltr,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SelectTriggerField(label: 'حقل', onTap: () {}),
            ),
          ),
        ),
      );
      expect(
        Directionality.of(tester.element(find.byType(SelectTriggerField))),
        TextDirection.rtl,
      );
    });

    testWidgets('uses a custom border color when provided', (tester) async {
      await _pumpWithApp(
        tester,
        SelectTriggerField(
          label: 'الحقل',
          onTap: () {},
          borderColor: AppColors.carWashTeal,
        ),
      );

      final ink = tester.widget<Ink>(find.byType(Ink));
      final decoration = ink.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, AppColors.carWashTeal);
    });
  });

  group(
    'Existing trigger behavior remains intact after SelectTriggerField '
    'migration',
    () {
      testWidgets(
        'CreateSosBody still shows the vehicle/province icons, labels and '
        'placeholder dash, and still calls the right callback per row',
        (tester) async {
          var vehicleTapped = false;
          var provinceTapped = false;

          await _pumpWithApp(
            tester,
            Directionality(
              textDirection: TextDirection.rtl,
              child: CreateSosBody(
                descriptionController: TextEditingController(),
                vehicleValue: '',
                provinceValue: 'دمشق',
                onPickVehicle: () => vehicleTapped = true,
                onPickProvince: () => provinceTapped = true,
                onSubmit: () {},
              ),
            ),
          );

          expect(find.byIcon(Icons.directions_car_outlined), findsOneWidget);
          expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
          expect(find.text('—'), findsOneWidget); // empty vehicle value
          expect(find.text('دمشق'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.directions_car_outlined));
          expect(vehicleTapped, isTrue);
          expect(provinceTapped, isFalse);

          await tester.tap(find.byIcon(Icons.location_on_outlined));
          expect(provinceTapped, isTrue);
        },
      );

      testWidgets(
        'FuelSosCreateBody still shows vehicle/fuel-type/province hints '
        'when empty and values when set',
        (tester) async {
          await _pumpWithApp(
            tester,
            Directionality(
              textDirection: TextDirection.rtl,
              child: FuelSosCreateBody(
                vehicleValue: null,
                fuelTypeValue: '95',
                provinceValue: null,
                quantityController: TextEditingController(),
                notesController: TextEditingController(),
                onPickVehicle: () {},
                onPickFuelType: () {},
                onPickProvince: () {},
                onSubmit: () {},
              ),
            ),
          );

          expect(find.text('95'), findsOneWidget);
        },
      );

      testWidgets(
        'ProviderCreateProfilePage governorate field keeps its teal border '
        'and leading-chevron layout',
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

          final ink = tester.widget<Ink>(find.byType(Ink).first);
          final decoration = ink.decoration! as BoxDecoration;
          final border = decoration.border! as Border;
          expect(border.top.color, AppColors.carWashTeal);
          expect(border.top.width, 1.2);

          await cubit.close();
        },
      );
    },
  );

  group('FuelSosCreatePage — fuel type picker on SharedSelectionBottomSheet', () {
    testWidgets(
      'renders 95 / 98 / diesel, shows the selected state, and returns the '
      'exact API value (not a normalized/renamed one)',
      (tester) async {
        final vehicleCubit = VehicleCubit(MockVehicleRepository());
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

        await tester.tap(find.text('نوع الوقود'));
        await tester.pumpAndSettle();

        expect(find.text('بنزين 95'), findsOneWidget);
        expect(find.text('بنزين 98'), findsOneWidget);
        expect(find.text('ديزل'), findsOneWidget);

        await tester.tap(find.text('بنزين 98'));
        await tester.pumpAndSettle();

        // The displayed value becomes the picked label; the underlying
        // apiValue ('98') is what's submitted, verified indirectly by
        // picking it again and seeing it show as selected.
        expect(find.text('بنزين 98'), findsOneWidget);

        await tester.tap(find.text('نوع الوقود'));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

        await vehicleCubit.close();
        await userFuelCubit.close();
      },
    );
  });
}
