import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/features/technician_sos/domain/entities/technician_sos_entity.dart';
import 'package:car_care/features/technician_sos/domain/repositories/i_technician_sos_repository.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/technician_sos_request_type.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_requests_list_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTechnicianSosRepository extends Mock
    implements ITechnicianSosRepository {}

TechnicianSosEntity _fakeSos({int id = 1, String status = 'open'}) {
  return TechnicianSosEntity(
    id: id,
    status: status,
    statusText: status,
    description: 'وصف تجريبي',
    plateNumber: '12345',
    vehicleBrand: 'تويوتا',
    vehicleModel: 'كورولا',
    vehicleYear: '2020',
    ownerName: 'أحمد',
    createdAgo: 'منذ 5 دقائق',
  );
}

Future<void> _pumpPage(WidgetTester tester, Widget child) async {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('A RenderFlex overflowed')) {
      return;
    }
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);

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

void main() {
  group('SOS accept action-error minimal UX fix', () {
    testWidgets(
      'accept failure keeps the loaded list on screen and shows a snackbar '
      'instead of a full-page ErrorStateWidget',
      (tester) async {
        final repo = MockTechnicianSosRepository();
        when(
          () => repo.getAvailableRequests(),
        ).thenAnswer((_) async => Right([_fakeSos()]));
        when(() => repo.acceptRequest(1)).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل قبول الطلب')),
        );

        final cubit = TechnicianSosCubit(repo);

        await _pumpPage(
          tester,
          BlocProvider.value(
            value: cubit,
            child: const TechnicianSosRequestsListPage(
              type: SosRequestType.available,
            ),
          ),
        );

        expect(find.text('قبول الطلب'), findsOneWidget);
        expect(find.byType(ErrorStateWidget), findsNothing);

        await tester.tap(find.text('قبول الطلب'));
        await tester.pumpAndSettle();

        expect(find.byType(ErrorStateWidget), findsNothing);
        expect(find.text('قبول الطلب'), findsOneWidget);

        expect(find.text('فشل قبول الطلب'), findsOneWidget);
      },
    );

    testWidgets(
      'initial load failure with no prior data still shows ErrorStateWidget '
      '(unchanged behavior)',
      (tester) async {
        final repo = MockTechnicianSosRepository();
        when(() => repo.getAvailableRequests()).thenAnswer(
          (_) async => const Left(Failure(message: 'فشل تحميل الطلبات')),
        );

        final cubit = TechnicianSosCubit(repo);

        await _pumpPage(
          tester,
          BlocProvider.value(
            value: cubit,
            child: const TechnicianSosRequestsListPage(
              type: SosRequestType.available,
            ),
          ),
        );

        expect(find.byType(ErrorStateWidget), findsOneWidget);
        expect(find.text('فشل تحميل الطلبات'), findsWidgets);
      },
    );
  });
}
