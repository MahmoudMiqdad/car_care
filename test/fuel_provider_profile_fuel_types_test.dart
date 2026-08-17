// تعديل الملف تعتمد فعليًا على profile.fuelTypes/profile.prices القادمة من
// ("OCT 90"/"OCT 95"/"OCT 98")، وأن تعطيل نوع وقود يحذفه من كليهما.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/domain/repositories/i_provider_profile_repository.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/pages/provider_edit_profile_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepo extends Mock implements IFuelProviderProfileRepository {}

FuelProviderProfileEntity _profile({
  List<String>? fuelTypes,
  Map<String, double>? prices,
}) =>
    FuelProviderProfileEntity(
      id: 1,
      companyName: 'مزود تجربة',
      phone: '0999999999',
      city: 'دمشق',
      address: 'شارع الثورة',
      fuelTypes: fuelTypes,
      prices: prices,
      isAvailable: true,
    );

const _testSurfaceSize = Size(375, 1800);

Widget _wrap(FuelProviderProfileEntity? profile, IFuelProviderProfileRepository repo) {
  return ScreenUtilInit(
    designSize: _testSurfaceSize,
    builder: (context, _) => MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<FuelProviderProfileCubit>(
        create: (_) => FuelProviderProfileCubit(repo),
        child: ProviderEditProfilePage(profile: profile),
      ),
    ),
  );
}

Future<void> _pumpPage(
  WidgetTester tester,
  FuelProviderProfileEntity? profile,
  IFuelProviderProfileRepository repo,
) async {
  // Match ScreenUtilInit's designSize exactly so .h/.w scaling factors stay
  // 1:1 and nothing renders outside the test surface.
  tester.view.physicalSize = _testSurfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(_wrap(profile, repo));
  await tester.pumpAndSettle();
}

Future<void> _tapFuelCard(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.pump();
  await tester.tap(find.text(label));
  // Let the bottom sheet's entrance animation fully settle before
  // interacting with it — otherwise it's still mid-slide, off-screen.
  await tester.pumpAndSettle();
}

Future<void> _enterPriceAndSaveDialog(WidgetTester tester, String price) async {
  await tester.enterText(find.byType(TextField).last, price);
  await tester.pump();
  await tester.tap(find.text('حفظ'));
  await tester.pumpAndSettle();
}

void main() {
  late MockRepo repo;

  setUp(() {
    repo = MockRepo();
    // Return a Left(Failure) so the cubit emits an error state instead of a
    // success state — success would trigger context.safePopOrGo(), which
    // needs a real GoRouter in the widget tree that these tests don't set
    // up. We only need to capture the request body that was sent, not the
    // post-save navigation.
    when(() => repo.addProfile(any())).thenAnswer(
      (_) async => const Left(Failure(message: 'error')),
    );
  });

  testWidgets(
    'profile fuel_types=null/prices=null: لا خدمة مفعّلة، كل البطاقات الثلاث تعرض دعوة التفعيل',
    (tester) async {
      await _pumpPage(tester, _profile(), repo);

      expect(find.text('OCT 90'), findsOneWidget);
      expect(find.text('OCT 95'), findsOneWidget);
      expect(find.text('OCT 98'), findsOneWidget);

      // كل البطاقات الثلاث بلا سعر — تعرض دعوة التفعيل، لا نص سعر إطلاقًا.
      expect(find.text('تفعيل الخدمة و تحديد السعر'), findsNWidgets(3));
      expect(find.textContaining('السعر :'), findsNothing);
    },
  );

  testWidgets(
    'profile fuel_types=["95"], prices={"95":2.5}: OCT 95 يظهر مفعلاً بسعر 2.5 فقط',
    (tester) async {
      await _pumpPage(
        tester,
        _profile(fuelTypes: const ['95'], prices: const {'95': 2.5}),
        repo,
      );

      expect(find.text('السعر : 2.5 \$'), findsOneWidget);
      // النوعان الآخران يبقيان غير مفعّلين.
      expect(find.text('تفعيل الخدمة و تحديد السعر'), findsNWidgets(2));
    },
  );

  testWidgets(
    'تفعيل OCT 98 بسعر 3.0 يرسل fuel_types=["98"] و prices={"98":3.0} دون أي مفتاح label',
    (tester) async {
      await _pumpPage(tester, _profile(), repo);

      await _tapFuelCard(tester, 'OCT 98');
      await _enterPriceAndSaveDialog(tester, '3.0');

      await tester.ensureVisible(find.text('حفظ المعلومات'));
      await tester.tap(find.text('حفظ المعلومات'));
      await tester.pumpAndSettle();

      final body = verify(() => repo.addProfile(captureAny())).captured.single
          as Map<String, dynamic>;

      expect(body['fuel_types'], ['98']);
      expect(body['prices'], {'98': 3.0});
      // لا وجود إطلاقًا لأي مفتاح بصيغة label داخل الطلب.
      expect(body['prices'].toString().contains('OCT'), isFalse);
      expect(body['fuel_types'].toString().contains('OCT'), isFalse);
    },
  );

  testWidgets(
    'لا يظهر أي مفتاح "OCT 95" داخل جسم الطلب حتى عند تفعيل عدة أنواع',
    (tester) async {
      await _pumpPage(tester, _profile(), repo);

      await _tapFuelCard(tester, 'OCT 90');
      await _enterPriceAndSaveDialog(tester, '1.5');

      await _tapFuelCard(tester, 'OCT 95');
      await _enterPriceAndSaveDialog(tester, '2.5');

      await tester.ensureVisible(find.text('حفظ المعلومات'));
      await tester.tap(find.text('حفظ المعلومات'));
      await tester.pumpAndSettle();

      final body = verify(() => repo.addProfile(captureAny())).captured.single
          as Map<String, dynamic>;

      expect(body['fuel_types'], containsAll(['90', '95']));
      expect((body['prices'] as Map).keys, containsAll(['90', '95']));
      expect((body['prices'] as Map).keys, isNot(contains('OCT 95')));
      expect((body['prices'] as Map).keys, isNot(contains('OCT 90')));
    },
  );

  testWidgets(
    'تعطيل نوع وقود مفعّل (مسح السعر) يحذفه من fuel_types و prices عند الحفظ',
    (tester) async {
      await _pumpPage(
        tester,
        _profile(fuelTypes: const ['95'], prices: const {'95': 2.5}),
        repo,
      );

      // OCT 95 مفعّل ابتداءً — نفتحه ونمسح السعر بالكامل لتعطيله.
      await _tapFuelCard(tester, 'OCT 95');
      await _enterPriceAndSaveDialog(tester, '');

      // البطاقة يجب أن تعود لحالة "غير مفعّل" في الواجهة فورًا.
      expect(find.text('تفعيل الخدمة و تحديد السعر'), findsNWidgets(3));

      await tester.ensureVisible(find.text('حفظ المعلومات'));
      await tester.tap(find.text('حفظ المعلومات'));
      await tester.pumpAndSettle();

      final body = verify(() => repo.addProfile(captureAny())).captured.single
          as Map<String, dynamic>;

      expect(body['fuel_types'], isEmpty);
      expect(body['prices'], isEmpty);
    },
  );
}
