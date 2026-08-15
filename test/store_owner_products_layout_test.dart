// يثبت عدم حدوث RenderFlex Overflow في واجهات منتجات المالك المعاد
// تصميمها (STORE-OWNER-PRODUCTS-UI-01) عند عروض شاشة واقعية: 320/360/375/412.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/products/domain/repositories/i_owner_products_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_add_product_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_products_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/widgets/owner_product_edit_sheet.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIOwnerProductsRepository extends Mock
    implements IOwnerProductsRepository {}

ProductEntity _fakeProduct({
  int id = 1,
  String name = 'قطعة غيار محرك أصلية طويلة الاسم للاختبار',
  double price = 1250,
  int stock = 42,
}) {
  return ProductEntity(
    id: id,
    name: name,
    description: 'وصف تجريبي للمنتج يستخدم في اختبار التخطيط',
    price: price,
    discountPrice: null,
    finalPrice: price,
    stockQuantity: stock,
    weightKg: null,
    dimensions: null,
    isNew: true,
    isFeatured: false,
    carBrandName: 'Mercedes-Benz',
    partCategoryName: 'حساسات وكمبيوتر',
    images: const [],
    primaryImage: null,
    createdAt: null,
  );
}

Future<void> pumpAt(
  WidgetTester tester,
  Widget child, {
  required double logicalWidth,
}) async {
  tester.view.physicalSize = Size(logicalWidth, logicalWidth * 2.16);
  tester.view.devicePixelRatio = 1.0;
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  const widths = [320.0, 360.0, 375.0, 412.0];

  for (final width in widths) {
    group('عرض $width', () {
      testWidgets('OwnerProductsPage — قائمة محمّلة بمنتج طويل الاسم', (
        tester,
      ) async {
        final repo = MockIOwnerProductsRepository();
        when(
          () => repo.getProducts(),
        ).thenAnswer((_) async => Right([_fakeProduct()]));

        if (getIt.isRegistered<OwnerProductsCubit>()) {
          getIt.unregister<OwnerProductsCubit>();
        }
        getIt.registerFactory<OwnerProductsCubit>(
          () => OwnerProductsCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<OwnerProductsCubit>()) {
            getIt.unregister<OwnerProductsCubit>();
          }
        });

        await pumpAt(tester, const OwnerProductsPage(), logicalWidth: width);

        expect(tester.takeException(), isNull);
      });

      testWidgets('OwnerProductsPage — قائمة فارغة (يظهر زر الإضافة فقط)', (
        tester,
      ) async {
        final repo = MockIOwnerProductsRepository();
        when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));

        if (getIt.isRegistered<OwnerProductsCubit>()) {
          getIt.unregister<OwnerProductsCubit>();
        }
        getIt.registerFactory<OwnerProductsCubit>(
          () => OwnerProductsCubit(repo),
        );
        addTearDown(() {
          if (getIt.isRegistered<OwnerProductsCubit>()) {
            getIt.unregister<OwnerProductsCubit>();
          }
        });

        await pumpAt(tester, const OwnerProductsPage(), logicalWidth: width);

        expect(tester.takeException(), isNull);
      });

      testWidgets('OwnerAddProductPage — البطاقات الأربع بلا تفاعل', (
        tester,
      ) async {
        final repo = MockIOwnerProductsRepository();
        when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));
        final cubit = OwnerProductsCubit(repo);
        await cubit.fetchProducts();

        await pumpAt(
          tester,
          BlocProvider.value(value: cubit, child: const OwnerAddProductPage()),
          logicalWidth: width,
        );

        expect(tester.takeException(), isNull);

        await cubit.close();
      });

      testWidgets('OwnerAddProductPage — بعد اختيار تصنيفات بأسماء طويلة', (
        tester,
      ) async {
        final repo = MockIOwnerProductsRepository();
        when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));
        final cubit = OwnerProductsCubit(repo);
        await cubit.fetchProducts();

        await pumpAt(
          tester,
          BlocProvider.value(value: cubit, child: const OwnerAddProductPage()),
          logicalWidth: width,
        );

        // اختيار ماركة سيارة باسم طويل نسبيًا (Mercedes-Benz)
        await tester.tap(find.text('ماركة السيارة'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Mercedes-Benz'));
        await tester.pump();
        await tester.tap(find.text('تأكيد الاختيار'));
        await tester.pumpAndSettle();

        // اختيار فئة قطعة باسم طويل (حساسات وكمبيوتر) — العنصر بعيد في
        // القائمة فيلزم تمريره داخل نطاق الصفحة ليصبح مبنيًا وقابلًا للنقر.
        await tester.tap(find.text('فئة القطعة'));
        await tester.pumpAndSettle();
        await tester.dragUntilVisible(
          find.text('حساسات وكمبيوتر'),
          find.byType(ListView),
          const Offset(0, -60),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('حساسات وكمبيوتر'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('حساسات وكمبيوتر'), warnIfMissed: false);
        await tester.pump();
        await tester.tap(find.text('تأكيد الاختيار'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Mercedes-Benz'), findsOneWidget);
        expect(find.text('حساسات وكمبيوتر'), findsOneWidget);

        await cubit.close();
      });

      testWidgets('OwnerProductEditSheet — منتج باسم/رقم أطول', (tester) async {
        tester.view.physicalSize = Size(width, width * 2.16);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, _) => MaterialApp(
              locale: const Locale('ar'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () => OwnerProductEditSheet.show(
                        context,
                        product: _fakeProduct(price: 1250000, stock: 999999),
                      ),
                      child: const Text('open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    });
  }
}
