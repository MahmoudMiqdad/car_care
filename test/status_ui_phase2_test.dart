import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoices_list_entity.dart';
import 'package:car_care/features/provider_invoices/domain/repositories/i_provider_invoices_repository.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/list/provider_invoices_cubit.dart';
import 'package:car_care/features/provider_invoices/presentation/pages/provider_invoices_page.dart';
import 'package:car_care/features/technician/technician_jobs/domain/entities/technician_jobs_entity.dart';
import 'package:car_care/features/technician/technician_jobs/domain/repositories/i_technician_jobs_repository.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/pages/technician_jobs_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTechnicianJobsRepository extends Mock
    implements ITechnicianJobsRepository {}

class MockProviderInvoicesRepository extends Mock
    implements IProviderInvoicesRepository {}

JobEntity _fakeJob({
  required int id,
  required String status,
  required String customerName,
}) {
  return JobEntity(
    id: id,
    status: status,
    scheduledDate: DateTime(2026, 1, 1),
    notes: '',
    customerName: customerName,
  );
}

ProviderInvoiceEntity _fakeInvoice({
  required int id,
  required String status,
  required String invoiceNumber,
}) {
  return ProviderInvoiceEntity(
    id: id,
    invoiceNumber: invoiceNumber,
    effectiveStatus: status,
    totalAmount: 100,
  );
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

GoRouter _routerFor(String path, Widget page) => GoRouter(
  initialLocation: path,
  routes: [GoRoute(path: path, builder: (context, state) => page)],
);

Future<void> _tapTab(WidgetTester tester, String label) async {
  final tabFinder = find.descendant(
    of: find.byType(StatusFilterTabs<String?>),
    matching: find.text(label),
  );
  await tester.ensureVisible(tabFinder);
  await tester.pump();
  await tester.tap(tabFinder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('My Jobs status tabs', () {
    testWidgets(
      'shows all jobs by default and filters when a status tab is tapped',
      (tester) async {
        final repo = MockTechnicianJobsRepository();
        when(() => repo.fetchMyJobs()).thenAnswer(
          (_) async => Right(
            TechnicianJobsEntity(
              success: true,
              jobs: [
                _fakeJob(id: 1, status: 'assigned', customerName: 'عميل مسند'),
                _fakeJob(
                  id: 2,
                  status: 'completed',
                  customerName: 'عميل مكتمل',
                ),
                _fakeJob(id: 3, status: 'accepted', customerName: 'عميل مقبول'),
              ],
            ),
          ),
        );

        if (getIt.isRegistered<TechnicianJobsCubit>()) {
          getIt.unregister<TechnicianJobsCubit>();
        }
        getIt.registerFactory<TechnicianJobsCubit>(
          () => TechnicianJobsCubit(repo),
        );
        addTearDown(() => getIt.unregister<TechnicianJobsCubit>());

        await _pumpRouter(
          tester,
          _routerFor('/technician-jobs', const TechnicianJobsPage()),
        );

        expect(find.textContaining('عميل مسند'), findsOneWidget);
        expect(find.textContaining('عميل مكتمل'), findsOneWidget);
        expect(find.textContaining('عميل مقبول'), findsOneWidget);

        await _tapTab(tester, 'مكتمل');

        expect(find.textContaining('عميل مكتمل'), findsOneWidget);
        expect(find.textContaining('عميل مسند'), findsNothing);
        expect(find.textContaining('عميل مقبول'), findsNothing);

        await _tapTab(tester, 'الكل');

        expect(find.textContaining('عميل مسند'), findsOneWidget);
        expect(find.textContaining('عميل مكتمل'), findsOneWidget);
        expect(find.textContaining('عميل مقبول'), findsOneWidget);
      },
    );
  });

  group('My Invoices status tabs', () {
    testWidgets(
      'shows all invoices by default and filters when a status tab is tapped',
      (tester) async {
        final repo = MockProviderInvoicesRepository();
        when(() => repo.getMyInvoices()).thenAnswer(
          (_) async => Right(
            ProviderInvoicesListEntity(
              data: [
                _fakeInvoice(id: 1, status: 'paid', invoiceNumber: 'INV-1'),
                _fakeInvoice(id: 2, status: 'draft', invoiceNumber: 'INV-2'),
              ],
              meta: null,
            ),
          ),
        );

        await _pumpRouter(
          tester,
          _routerFor(
            '/provider-invoices',
            BlocProvider<ProviderInvoicesCubit>(
              create: (_) => ProviderInvoicesCubit(repo),
              child: const ProviderInvoicesPage(),
            ),
          ),
        );

        expect(find.textContaining('INV-1'), findsOneWidget);
        expect(find.textContaining('INV-2'), findsOneWidget);

        await _tapTab(tester, 'مدفوعة');

        expect(find.textContaining('INV-1'), findsOneWidget);
        expect(find.textContaining('INV-2'), findsNothing);
      },
    );
  });
}
