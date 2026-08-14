// اختبارات إعادة تصميم إحصائيات مزود الوقود على نمط إحصائيات المغسلة —
// إجمالي الطلبات، حالات الطلبات، إجمالي الأرباح، دون تقييمات، ودون طلبات
// إضافية أو تغيير في منطق التحميل.
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/entities/provider_statistics_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/domain/repositories/i_provider_statistics_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/cubit/provider_statistics_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_statistics/presentation/widgets/provider_statistics/provider_statistics_body.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFuelProviderStatisticsRepository extends Mock
    implements IFuelProviderStatisticsRepository {}

FuelProviderStatisticsEntity _fakeStats({
  int totalOrders = 42,
  int pendingOrders = 5,
  int acceptedOrders = 7,
  int inProgressOrders = 3,
  int completedOrders = 25,
  int cancelledOrders = 2,
  double totalRevenue = 1234,
}) {
  return FuelProviderStatisticsEntity(
    totalOrders: totalOrders,
    pendingOrders: pendingOrders,
    acceptedOrders: acceptedOrders,
    inProgressOrders: inProgressOrders,
    completedOrders: completedOrders,
    cancelledOrders: cancelledOrders,
    totalRevenue: totalRevenue,
  );
}

Future<FuelProviderStatisticsCubit> _loadedCubit(
  MockFuelProviderStatisticsRepository repo,
  FuelProviderStatisticsEntity stats,
) async {
  when(() => repo.getStatistics()).thenAnswer((_) async => Right(stats));
  final cubit = FuelProviderStatisticsCubit(repo);
  await cubit.getStatistics();
  return cubit;
}

Future<void> _pumpBody(
  WidgetTester tester,
  FuelProviderStatisticsCubit cubit,
) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const ProviderStatisticsBody(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('ProviderStatisticsBody — new design (reused core/widgets/statistics)', () {
    testWidgets('shows "اجمالي الطلبات" with the real total, exactly one '
        'getStatistics() request', (tester) async {
      final repo = MockFuelProviderStatisticsRepository();
      final cubit = await _loadedCubit(repo, _fakeStats(totalOrders: 42));

      await _pumpBody(tester, cubit);

      expect(find.text('اجمالي الطلبات'), findsWidgets);
      expect(find.text('42'), findsOneWidget);
      verify(() => repo.getStatistics()).called(1);
    });

    testWidgets(
      'shows pending/accepted/in_progress with their real counts',
      (tester) async {
        final repo = MockFuelProviderStatisticsRepository();
        final cubit = await _loadedCubit(
          repo,
          _fakeStats(pendingOrders: 5, acceptedOrders: 7, inProgressOrders: 3),
        );

        await _pumpBody(tester, cubit);

        expect(find.text('حالات الطلبات'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('7'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      },
    );

    testWidgets(
      'shows completed/cancelled as legend chips under the summary bar',
      (tester) async {
        final repo = MockFuelProviderStatisticsRepository();
        final cubit = await _loadedCubit(
          repo,
          _fakeStats(completedOrders: 25, cancelledOrders: 2),
        );

        await _pumpBody(tester, cubit);

        expect(find.textContaining('25'), findsWidgets);
        expect(find.textContaining('2'), findsWidgets);
      },
    );

    testWidgets('shows total profits using the existing value/format', (
      tester,
    ) async {
      final repo = MockFuelProviderStatisticsRepository();
      final cubit = await _loadedCubit(repo, _fakeStats(totalRevenue: 1234));

      await _pumpBody(tester, cubit);

      expect(find.text('اجمالي الأرباح'), findsOneWidget);
      expect(find.text('\$ 1,234'), findsOneWidget);
    });

    testWidgets(
      'never shows any ratings/reviews content — not available for fuel',
      (tester) async {
        final repo = MockFuelProviderStatisticsRepository();
        final cubit = await _loadedCubit(repo, _fakeStats());

        await _pumpBody(tester, cubit);

        expect(find.textContaining('تقييم'), findsNothing);
        expect(find.textContaining('مراجع'), findsNothing);
      },
    );

    testWidgets(
      'an all-zero statistics response renders safely — flat segmented bar, '
      'zeros shown, no overflow/exception',
      (tester) async {
        final repo = MockFuelProviderStatisticsRepository();
        final cubit = await _loadedCubit(
          repo,
          _fakeStats(
            totalOrders: 0,
            pendingOrders: 0,
            acceptedOrders: 0,
            inProgressOrders: 0,
            completedOrders: 0,
            cancelledOrders: 0,
            totalRevenue: 0,
          ),
        );

        await _pumpBody(tester, cubit);

        expect(find.text('0'), findsWidgets);
        expect(find.text('\$ 0'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'rebuilding the widget tree triggers no additional getStatistics() '
      'request — loading stays exactly as-is',
      (tester) async {
        final repo = MockFuelProviderStatisticsRepository();
        final cubit = await _loadedCubit(repo, _fakeStats());

        await _pumpBody(tester, cubit);
        await tester.pump();
        await tester.pump();

        verify(() => repo.getStatistics()).called(1);
      },
    );
  });
}
