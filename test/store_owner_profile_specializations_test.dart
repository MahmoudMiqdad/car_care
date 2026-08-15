// يثبت: 1) ملف المتجر يعرض المعلومات الأساسية فقط (بلا تخصصات ولا أيقونة
// طلبات) عند تعديل متجر قائم، بينما يُبقي اختيار التخصصات ضمن فلو الإنشاء
// الأولي. 2) صفحة تخصصات المتجر تعرض البطاقات الثلاث، وتعديل مجموعة واحدة
// يحفظ الحمولة كاملة مع الحفاظ على المجموعتين الأخريين، ولا يرسل طلبًا عند
// تأكيد الاختيار دون تغيير فعلي.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/domain/repositories/i_owner_profile_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/pages/owner_profile_page.dart';
import 'package:car_care/features/spare_parts_store/owner/specializations/presentation/pages/owner_specializations_page.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIOwnerProfileRepository extends Mock
    implements IOwnerProfileRepository {}

ShopEntity _approvedShop() {
  return const ShopEntity(
    id: 1,
    name: 'متجر تجريبي',
    phone: '0999999999',
    city: 'دمشق',
    isActive: true,
    owner: null,
    businessTypes: ['قطع غيار مستعملة/كسر'],
    carBrands: ['Toyota'],
    partCategories: ['فرامل وديسكات'],
    createdAt: null,
    status: 'approved',
  );
}

Future<void> pumpWithApp(WidgetTester tester, Widget child) async {
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
  group('ملف المتجر — معلومات أساسية فقط لمتجر قائم', () {
    testWidgets(
      'يعرض الاسم/الهاتف/المدينة/الحالة، ولا يعرض التخصصات ولا أيقونة الطلبات',
      (tester) async {
        final repo = MockIOwnerProfileRepository();
        when(
          () => repo.getProfile(),
        ).thenAnswer((_) async => Right(_approvedShop()));

        if (getIt.isRegistered<OwnerProfileCubit>()) {
          getIt.unregister<OwnerProfileCubit>();
        }
        getIt.registerFactory<OwnerProfileCubit>(() => OwnerProfileCubit(repo));
        addTearDown(() {
          if (getIt.isRegistered<OwnerProfileCubit>()) {
            getIt.unregister<OwnerProfileCubit>();
          }
        });

        await pumpWithApp(tester, const OwnerProfilePage());

        // المعلومات الأساسية
        expect(find.text('اسم المتجر'), findsOneWidget);
        expect(find.text('رقم الهاتف'), findsOneWidget);
        expect(find.text('المدينة'), findsOneWidget);
        expect(find.text('نشط'), findsOneWidget); // شارة الحالة (approved)

        // لا تخصصات ولا أيقونة طلبات في هذه الصفحة بعد إنشاء المتجر
        expect(find.text('نوع النشاط'), findsNothing);
        expect(find.text('ماركات السيارات'), findsNothing);
        expect(find.text('فئات القطع'), findsNothing);
        expect(find.byIcon(Icons.list_alt_outlined), findsNothing);
      },
    );
  });

  group('صفحة تخصصات المتجر', () {
    late MockIOwnerProfileRepository repo;

    setUp(() {
      repo = MockIOwnerProfileRepository();
      when(
        () => repo.getProfile(),
      ).thenAnswer((_) async => Right(_approvedShop()));
      when(
        () => repo.saveProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          city: any(named: 'city'),
          businessTypeIds: any(named: 'businessTypeIds'),
          carBrandIds: any(named: 'carBrandIds'),
          partCategoryIds: any(named: 'partCategoryIds'),
        ),
      ).thenAnswer((_) async => Right(_approvedShop()));

      if (getIt.isRegistered<OwnerProfileCubit>()) {
        getIt.unregister<OwnerProfileCubit>();
      }
      getIt.registerFactory<OwnerProfileCubit>(() => OwnerProfileCubit(repo));
    });

    tearDown(() {
      if (getIt.isRegistered<OwnerProfileCubit>()) {
        getIt.unregister<OwnerProfileCubit>();
      }
    });

    testWidgets('تعرض البطاقات الثلاث بالقيم الحالية', (tester) async {
      await pumpWithApp(tester, const OwnerSpecializationsPage());

      expect(find.text('نوع النشاط'), findsOneWidget);
      expect(find.text('ماركات السيارات'), findsOneWidget);
      expect(find.text('فئات القطع'), findsOneWidget);
      expect(find.text('قطع غيار مستعملة/كسر'), findsOneWidget);
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('فرامل وديسكات'), findsOneWidget);
    });

    testWidgets(
      'تعديل ماركات السيارات فقط يحفظ الحمولة كاملة مع تثبيت المجموعتين الأخريين',
      (tester) async {
        await pumpWithApp(tester, const OwnerSpecializationsPage());

        // زر «تعديل» الثاني هو الخاص ببطاقة «ماركات السيارات»
        final editButtons = find.widgetWithText(OutlinedButton, 'تعديل');
        expect(editButtons, findsNWidgets(3));
        await tester.tap(editButtons.at(1));
        await tester.pumpAndSettle();

        // إضافة Hyundai (id=2) إلى جانب Toyota (id=1) المختارة أصلًا
        await tester.tap(find.text('Hyundai'));
        await tester.pump();
        await tester.tap(find.textContaining('تأكيد الاختيار'));
        await tester.pumpAndSettle();

        final captured = verify(
          () => repo.saveProfile(
            name: 'متجر تجريبي',
            phone: '0999999999',
            city: 'دمشق',
            businessTypeIds: captureAny(named: 'businessTypeIds'),
            carBrandIds: captureAny(named: 'carBrandIds'),
            partCategoryIds: captureAny(named: 'partCategoryIds'),
          ),
        ).captured;

        expect(captured[0], [1]); // نوع النشاط لم يتغيّر
        expect((captured[1] as List<int>)..sort(), [
          1,
          2,
        ]); // ماركات السيارات تغيّرت
        expect(captured[2], [1]); // فئات القطع لم تتغيّر
      },
    );

    testWidgets('لا يُرسل طلب عند تأكيد الاختيار دون أي تغيير فعلي', (
      tester,
    ) async {
      await pumpWithApp(tester, const OwnerSpecializationsPage());

      final editButtons = find.widgetWithText(OutlinedButton, 'تعديل');
      await tester.tap(editButtons.first); // بطاقة «نوع النشاط»
      await tester.pumpAndSettle();

      // تأكيد دون تبديل أي اختيار
      await tester.tap(find.textContaining('تأكيد الاختيار'));
      await tester.pumpAndSettle();

      verifyNever(
        () => repo.saveProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          city: any(named: 'city'),
          businessTypeIds: any(named: 'businessTypeIds'),
          carBrandIds: any(named: 'carBrandIds'),
          partCategoryIds: any(named: 'partCategoryIds'),
        ),
      );
    });
  });
}
