import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/domain/repositories/i_technician_sos_repository.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/pages/sos_details_page.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_requests_list_page.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_body.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTechnicianSosRepository extends Mock
    implements ITechnicianSosRepository {}

TechnicianSosEntity _fakeSos({int id = 1, String status = 'open'}) {
  return TechnicianSosEntity(
    id: id,
    status: status,
    statusText: status,
    description: 'وصف تجريبي فريد',
    plateNumber: '12345',
    vehicleBrand: 'تويوتا',
    vehicleModel: 'كورولا',
    vehicleYear: '2020',
    ownerName: 'أحمد',
    createdAgo: 'منذ 5 دقائق',
  );
}

void _ignoreKnownOverflowInTests() {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('A RenderFlex overflowed')) {
      return;
    }
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
}

Future<void> _pumpPage(WidgetTester tester, Widget child) async {
  _ignoreKnownOverflowInTests();
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
  await tester.pumpAndSettle();
}

Future<void> _pumpRouter(WidgetTester tester, GoRouter router) async {
  _ignoreKnownOverflowInTests();
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

void _registerCubit(MockTechnicianSosRepository repo) {
  if (getIt.isRegistered<TechnicianSosCubit>()) {
    getIt.unregister<TechnicianSosCubit>();
  }
  getIt.registerFactory<TechnicianSosCubit>(() => TechnicianSosCubit(repo));
}

void main() {
  group('SOS details — accept action-error hardening', () {
    testWidgets(
      'a failed accept on the SOS details page keeps the loaded request on '
      'screen (no ErrorStateWidget, no blank) and shows a snackbar',
      (tester) async {
        final repo = MockTechnicianSosRepository();
        when(
          () => repo.getRequest(1),
        ).thenAnswer((_) async => Right(_fakeSos(status: 'open')));
        when(() => repo.acceptRequest(1)).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل قبول الطلب')),
        );

        _registerCubit(repo);
        addTearDown(() {
          if (getIt.isRegistered<TechnicianSosCubit>()) {
            getIt.unregister<TechnicianSosCubit>();
          }
        });

        final router = GoRouter(
          initialLocation: '/sos_details/1',
          routes: [
            GoRoute(
              path: '/sos_details/1',
              builder: (context, state) =>
                  const SosTechnicianDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);

        expect(find.byType(SosTechnicianDetailsBody), findsOneWidget);
        expect(find.textContaining('وصف تجريبي فريد'), findsOneWidget);
        expect(find.byType(ErrorStateWidget), findsNothing);

        await tester.tap(find.text('قبول الطلب'));
        await tester.pumpAndSettle();

        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.byType(SosTechnicianDetailsBody), findsOneWidget);
        expect(find.textContaining('وصف تجريبي فريد'), findsOneWidget);
        expect(find.text('فشل قبول الطلب'), findsOneWidget);
      },
    );
  });

  group('SOS — changeStatus action-error hardening', () {
    testWidgets(
      'a failed changeStatus from the "my requests" list keeps the card on '
      'screen (no ErrorStateWidget) and shows a snackbar',
      (tester) async {
        final repo = MockTechnicianSosRepository();
        when(
          () => repo.myRequests(),
        ).thenAnswer((_) async => Right([_fakeSos(status: 'accepted')]));
        when(() => repo.updateStatus(1, 'in_progress')).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل تغيير الحالة')),
        );

        final cubit = TechnicianSosCubit(repo);

        await _pumpPage(
          tester,
          BlocProvider.value(
            value: cubit,
            child: const TechnicianSosRequestsListPage(
              type: SosRequestType.myRequests,
            ),
          ),
        );

        expect(find.text('بدء التنفيذ'), findsOneWidget);
        expect(find.byType(ErrorStateWidget), findsNothing);

        await tester.tap(find.text('بدء التنفيذ'));
        await tester.pumpAndSettle();

        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.text('بدء التنفيذ'), findsOneWidget);
        expect(find.text('فشل تغيير الحالة'), findsOneWidget);
      },
    );
  });

  group('SOS — cancelResponse action-error hardening', () {
    testWidgets(
      'a failed cancelResponse on the SOS details page keeps the loaded '
      'request on screen and shows a snackbar',
      (tester) async {
        final repo = MockTechnicianSosRepository();
        when(
          () => repo.getRequest(1),
        ).thenAnswer((_) async => Right(_fakeSos(status: 'accepted')));
        when(() => repo.cancelResponse(1, any(that: isNotEmpty))).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل إلغاء الاستجابة')),
        );

        _registerCubit(repo);
        addTearDown(() {
          if (getIt.isRegistered<TechnicianSosCubit>()) {
            getIt.unregister<TechnicianSosCubit>();
          }
        });

        final router = GoRouter(
          initialLocation: '/sos_details/1',
          routes: [
            GoRoute(
              path: '/sos_details/1',
              builder: (context, state) =>
                  const SosTechnicianDetailsPage(id: 1),
            ),
          ],
        );

        await _pumpRouter(tester, router);
        expect(find.byType(SosTechnicianDetailsBody), findsOneWidget);
        expect(find.textContaining('وصف تجريبي فريد'), findsOneWidget);

        await tester.tap(find.text('إلغاء الاستجابة'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'سبب إلغاء كافٍ');
        await tester.tap(find.text('تأكيد الإلغاء'));
        await tester.pumpAndSettle();

        expect(find.byType(SosTechnicianDetailsPage), findsOneWidget);
        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.byType(SosTechnicianDetailsBody), findsOneWidget);
        expect(find.textContaining('وصف تجريبي فريد'), findsOneWidget);
        expect(find.text('فشل إلغاء الاستجابة'), findsOneWidget);
      },
    );
  });
}
