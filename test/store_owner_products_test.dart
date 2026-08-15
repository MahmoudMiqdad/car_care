// يثبت طبقة منتجات المالك: القائمة/الحذف/التعديل الجزئي (سعر ومخزون فقط)
// وفق العقد المثبت، الحذف Message-only، منع الضغط المكرر على الحذف
// والتعديل، وقواعد Refresh (صفر Requests إضافية بعد الفشل، تحديث محلي واحد
// فقط بعد النجاح دون أي GET إضافي)، وPull-to-Refresh على القائمة الفارغة.
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/products/data/data_sources/owner_products_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/owner/products/data/repositories/owner_products_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/owner/products/domain/repositories/i_owner_products_repository.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_state.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_add_product_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_products_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/widgets/owner_product_edit_sheet.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockIOwnerProductsRepository extends Mock
    implements IOwnerProductsRepository {}

ProductEntity _fakeProduct({int id = 1, double price = 100, int stock = 5}) {
  return ProductEntity(
    id: id,
    name: 'قطعة تجريبية $id',
    description: '',
    price: price,
    discountPrice: null,
    finalPrice: price,
    stockQuantity: stock,
    weightKg: null,
    dimensions: null,
    isNew: true,
    isFeatured: false,
    carBrandName: null,
    partCategoryName: null,
    images: const [],
    primaryImage: null,
    createdAt: null,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FormData());
  });

  group('OwnerProductsRemoteDataSource — Payload الدقيق', () {
    late MockApiService api;
    late OwnerProductsRemoteDataSource ds;

    setUp(() {
      api = MockApiService();
      ds = OwnerProductsRemoteDataSource(api);
    });

    test(
      'updateProduct(price فقط) يرسل price فقط دون stock_quantity',
      () async {
        when(
          () => api.put(
            endPoint: ApiEndpoints.ownerShopProductById(1),
            data: {'price': 150.0},
          ),
        ).thenAnswer(
          (_) async => {
            'data': {
              'id': 1,
              'name': 'x',
              'price': 150,
              'final_price': 150,
              'stock_quantity': 5,
            },
          },
        );

        await ds.updateProduct(1, {'price': 150.0});

        verify(
          () => api.put(
            endPoint: ApiEndpoints.ownerShopProductById(1),
            data: {'price': 150.0},
          ),
        ).called(1);
      },
    );

    test('deleteProduct لا يفترض إعادة Product — Message فقط', () async {
      when(
        () => api.delete(endPoint: ApiEndpoints.ownerShopProductById(2)),
      ).thenAnswer((_) async => {'success': true, 'message': 'تم الحذف'});

      final message = await ds.deleteProduct(2);

      expect(message, 'تم الحذف');
    });
  });

  group('OwnerProductsRepositoryImpl — تحديث جزئي', () {
    test(
      'updateProduct يبني data بالحقول المرسلة فقط (price/stock_quantity)',
      () async {
        final api = MockApiService();
        final repo = OwnerProductsRepositoryImpl(
          OwnerProductsRemoteDataSource(api),
        );
        when(
          () => api.put(
            endPoint: ApiEndpoints.ownerShopProductById(1),
            data: {'stock_quantity': 9},
          ),
        ).thenAnswer(
          (_) async => {
            'data': {
              'id': 1,
              'name': 'x',
              'price': 100,
              'final_price': 100,
              'stock_quantity': 9,
            },
          },
        );

        final result = await repo.updateProduct(1, stockQuantity: 9);

        expect(result.isRight(), isTrue);
        verify(
          () => api.put(
            endPoint: ApiEndpoints.ownerShopProductById(1),
            data: {'stock_quantity': 9},
          ),
        ).called(1);
      },
    );
  });

  group('OwnerProductsCubit', () {
    late MockIOwnerProductsRepository repo;
    late OwnerProductsCubit cubit;

    setUp(() {
      repo = MockIOwnerProductsRepository();
      cubit = OwnerProductsCubit(repo);
    });

    test('حذف ناجح: صفر GET إضافي — تحديث محلي فقط', () async {
      when(() => repo.getProducts()).thenAnswer(
        (_) async => Right([_fakeProduct(id: 1), _fakeProduct(id: 2)]),
      );
      when(
        () => repo.deleteProduct(1),
      ).thenAnswer((_) async => const Right('تم الحذف'));

      await cubit.fetchProducts();
      await cubit.deleteProduct(1);

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.map((p) => p.id), [2]);
      verify(() => repo.getProducts()).called(1); // مرة واحدة فقط طوال الاختبار
    });

    test('حذف فاشل: لا يُحذف المنتج من الواجهة، ولا GET إضافي', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1)]));
      when(
        () => repo.deleteProduct(1),
      ).thenAnswer((_) async => const Left(Failure(message: 'فشل الحذف')));

      await cubit.fetchProducts();
      await cubit.deleteProduct(1);

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.map((p) => p.id), [1]);
      expect(state.actionError, 'فشل الحذف');
      verify(() => repo.getProducts()).called(1);
    });

    test('منع الحذف المكرر لنفس المنتج أثناء التنفيذ', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1)]));
      when(() => repo.deleteProduct(1)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 30));
        return const Right('تم الحذف');
      });

      await cubit.fetchProducts();
      final f1 = cubit.deleteProduct(1);
      final f2 = cubit.deleteProduct(1); // ضغطة ثانية فورية
      await Future.wait([f1, f2]);

      verify(() => repo.deleteProduct(1)).called(1);
    });

    test('تعديل ناجح: تحديث محلي فوري دون أي GET إضافي', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1, price: 100)]));
      when(
        () => repo.updateProduct(1, price: 150, stockQuantity: null),
      ).thenAnswer((_) async => Right(_fakeProduct(id: 1, price: 150)));

      await cubit.fetchProducts();
      await cubit.updateProduct(1, price: 150);

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.single.price, 150);
      verify(() => repo.getProducts()).called(1);
    });

    test('تعديل فاشل: تبقى القيم السابقة، ولا نجاح زائف', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1, price: 100)]));
      when(
        () => repo.updateProduct(1, price: 150, stockQuantity: null),
      ).thenAnswer((_) async => const Left(Failure(message: 'فشل التعديل')));

      await cubit.fetchProducts();
      await cubit.updateProduct(1, price: 150);

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.single.price, 100);
      expect(state.actionError, 'فشل التعديل');
    });

    test('إنشاء ناجح: يُضاف المنتج محليًا دون أي GET إضافي', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1)]));
      when(
        () => repo.createProduct(any()),
      ).thenAnswer((_) async => Right(_fakeProduct(id: 9)));

      await cubit.fetchProducts();
      await cubit.createProduct(FormData());

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.map((p) => p.id), [9, 1]);
      expect(state.isCreating, isFalse);
      expect(state.createError, isNull);
      verify(() => repo.getProducts()).called(1);
    });

    test('إنشاء فاشل: لا يُضاف منتج، وتظهر رسالة الفشل', () async {
      when(
        () => repo.getProducts(),
      ).thenAnswer((_) async => Right([_fakeProduct(id: 1)]));
      when(() => repo.createProduct(any())).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل إنشاء المنتج')),
      );

      await cubit.fetchProducts();
      await cubit.createProduct(FormData());

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.map((p) => p.id), [1]);
      expect(state.createError, 'فشل إنشاء المنتج');
    });

    test('منع الضغط المكرر على الإنشاء أثناء التنفيذ', () async {
      when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));
      when(() => repo.createProduct(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 30));
        return Right(_fakeProduct(id: 5));
      });

      await cubit.fetchProducts();
      final f1 = cubit.createProduct(FormData());
      final f2 = cubit.createProduct(FormData()); // ضغطة ثانية فورية
      await Future.wait([f1, f2]);

      verify(() => repo.createProduct(any())).called(1);
    });

    test('إنشاء من قائمة فارغة: يحوّلها Loaded بمنتج واحد', () async {
      when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));
      when(
        () => repo.createProduct(any()),
      ).thenAnswer((_) async => Right(_fakeProduct(id: 3)));

      await cubit.fetchProducts();
      expect(cubit.state, isA<OwnerProductsEmpty>());

      await cubit.createProduct(FormData());

      final state = cubit.state as OwnerProductsLoaded;
      expect(state.products.map((p) => p.id), [3]);
    });
  });

  group('OwnerAddProductPage — إضافة منتج', () {
    late MockIOwnerProductsRepository repo;
    late OwnerProductsCubit cubit;

    setUp(() {
      repo = MockIOwnerProductsRepository();
      cubit = OwnerProductsCubit(repo);
      when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));
    });

    Future<void> pumpPage(WidgetTester tester) async {
      // في الاستخدام الحقيقي تُفتح هذه الصفحة دائمًا من OwnerProductsPage
      // بعد أن يكون الـCubit قد حمّل القائمة بالفعل (Loaded/Empty)، وهذه
      // الحالة تحديدًا هي ما تسمح لـcreateProduct بالعمل (راجع الحارس فيه).
      await cubit.fetchProducts();

      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // تُدفع الصفحة فوق صفحة أساسية حقيقية عبر Navigator حتى يعمل
      // Navigator.pop() بعد النجاح تمامًا كما في الاستخدام الفعلي من
      // OwnerProductsPage (وليس كـhome مباشرة بلا شيء تحته).
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const OwnerAddProductPage(),
                        ),
                      ),
                    ),
                    child: const Text('open-add-product'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('open-add-product'));
      await tester.pumpAndSettle();
    }

    Future<void> fillRequiredFields(WidgetTester tester) async {
      await tester.enterText(
        find.byKey(const Key('add_product_name_field')),
        'منتج تجريبي',
      );
      await tester.enterText(
        find.byKey(const Key('add_product_price_field')),
        '120',
      );
      await tester.enterText(
        find.byKey(const Key('add_product_stock_field')),
        '10',
      );
    }

    testWidgets(
      'إرسال ناجح: يرسل الحقول المثبتة فقط وينجح مرة واحدة، ثم يُغلق النموذج',
      (tester) async {
        FormData? captured;
        when(() => repo.createProduct(any())).thenAnswer((invocation) async {
          captured = invocation.positionalArguments.first as FormData;
          return Right(_fakeProduct(id: 9, price: 120, stock: 10));
        });

        await pumpPage(tester);
        await fillRequiredFields(tester);

        await tester.tap(find.widgetWithText(ElevatedButton, 'حفظ المنتج'));
        await tester.pumpAndSettle();

        verify(() => repo.createProduct(any())).called(1);
        expect(captured, isNotNull);
        final fieldsMap = {for (final f in captured!.fields) f.key: f.value};
        expect(fieldsMap['name'], 'منتج تجريبي');
        expect(fieldsMap['price'], '120');
        expect(fieldsMap['stock_quantity'], '10');
        expect(fieldsMap['condition'], 'new');
        expect(fieldsMap.containsKey('description'), isFalse);
        expect(fieldsMap.containsKey('car_brand_id'), isFalse);

        // الصفحة أُغلقت بعد النجاح
        expect(find.byType(OwnerAddProductPage), findsNothing);
      },
    );

    testWidgets('منع الضغط المكرر: نقرتان سريعتان ترسلان طلبًا واحدًا فقط', (
      tester,
    ) async {
      when(() => repo.createProduct(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right(_fakeProduct(id: 9));
      });

      await pumpPage(tester);
      await fillRequiredFields(tester);

      // نستخدم Finder بالنوع فقط (وليس بالنص) لأن نص الزر يتحوّل إلى مؤشر
      // تحميل بمجرد بدء الإنشاء — البحث بالنص يفشل في محاولة الضغط الثانية
      // رغم أن الزر (المعطَّل الآن) ما يزال موجودًا فعليًا في الشجرة.
      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pump();
      await tester.tap(button, warnIfMissed: false); // ضغطة ثانية فورية
      await tester.pump(const Duration(milliseconds: 150));

      verify(() => repo.createProduct(any())).called(1);
    });

    testWidgets('فشل الإنشاء: لا يُغلق النموذج ولا يُضاف منتج محليًا', (
      tester,
    ) async {
      when(() => repo.createProduct(any())).thenAnswer(
        (_) async => const Left(Failure(message: 'فشل إنشاء المنتج')),
      );

      await pumpPage(tester);
      await fillRequiredFields(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'حفظ المنتج'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(OwnerAddProductPage), findsOneWidget);
      expect(find.text('فشل إنشاء المنتج'), findsOneWidget);
      expect((cubit.state as OwnerProductsLoaded).products, isEmpty);
    });

    testWidgets('Validation: لا يُرسل الطلب عند حقول ناقصة', (tester) async {
      await pumpPage(tester);
      // بلا تعبئة أي حقل

      await tester.tap(find.widgetWithText(ElevatedButton, 'حفظ المنتج'));
      await tester.pump();

      verifyNever(() => repo.createProduct(any()));
    });

    testWidgets(
      'لا Bottom Overflow عند ظهور لوحة مفاتيح واقعية، وزر «حفظ المنتج» يبقى ظاهرًا',
      (tester) async {
        await pumpPage(tester);
        expect(tester.takeException(), isNull);

        // محاكاة ظهور لوحة مفاتيح واقعية (بارتفاع فعلي كبير)
        const keyboardHeightPhysical = 900.0; // ~300 منطقي * devicePixelRatio 3
        tester.view.viewInsets = const FakeViewPadding(
          bottom: keyboardHeightPhysical,
        );
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('حفظ المنتج'), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsWidgets);
      },
    );

    testWidgets(
      'Bottom Sheet اختيار مفرد: تغيير حالة المنتج ينعكس على الصف والحمولة',
      (tester) async {
        FormData? captured;
        when(() => repo.createProduct(any())).thenAnswer((invocation) async {
          captured = invocation.positionalArguments.first as FormData;
          return Right(_fakeProduct(id: 9));
        });

        await pumpPage(tester);
        expect(find.text('جديد'), findsOneWidget);

        await tester.tap(find.text('حالة المنتج'));
        await tester.pumpAndSettle();

        expect(find.text('تأكيد الاختيار'), findsOneWidget);
        await tester.tap(find.text('مستعمل'));
        await tester.pump();
        await tester.tap(find.text('تأكيد الاختيار'));
        await tester.pumpAndSettle();

        expect(find.text('مستعمل'), findsOneWidget);

        await fillRequiredFields(tester);
        await tester.tap(find.widgetWithText(ElevatedButton, 'حفظ المنتج'));
        await tester.pumpAndSettle();

        final fieldsMap = {for (final f in captured!.fields) f.key: f.value};
        expect(fieldsMap['condition'], 'used');
      },
    );
  });

  group('OwnerProductEditSheet — لا Overflow مع لوحة المفاتيح', () {
    testWidgets(
      'يبقى زر «حفظ التعديل» ظاهرًا وقابلًا للتمرير عند ظهور لوحة مفاتيح واقعية',
      (tester) async {
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
              home: Scaffold(
                body: Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () => OwnerProductEditSheet.show(
                        context,
                        product: _fakeProduct(id: 1),
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

        // محاكاة ظهور لوحة مفاتيح واقعية (بارتفاع فعلي كبير)
        const keyboardHeightPhysical = 900.0; // ~300 منطقي * devicePixelRatio 3
        tester.view.viewInsets = const FakeViewPadding(
          bottom: keyboardHeightPhysical,
        );
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        expect(find.text('حفظ التعديل'), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      },
    );
  });

  group('OwnerProductsPage — Pull-to-Refresh على القائمة الفارغة', () {
    testWidgets('يستدعي fetchProducts مرة واحدة عبر سحب فعلي', (tester) async {
      final repo = MockIOwnerProductsRepository();
      when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));

      if (getIt.isRegistered<OwnerProductsCubit>()) {
        getIt.unregister<OwnerProductsCubit>();
      }
      getIt.registerFactory<OwnerProductsCubit>(() => OwnerProductsCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<OwnerProductsCubit>()) {
          getIt.unregister<OwnerProductsCubit>();
        }
      });

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
            home: const OwnerProductsPage(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      verify(() => repo.getProducts()).called(1);

      final scrollable = find.descendant(
        of: find.byType(RefreshIndicator),
        matching: find.byType(Scrollable),
      );
      await tester.fling(scrollable.first, const Offset(0, 300), 1000);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      verify(() => repo.getProducts()).called(1);
    });

    testWidgets('زر الإضافة أسفل اليمين (startFloat) وداخل SafeArea', (
      tester,
    ) async {
      final repo = MockIOwnerProductsRepository();
      when(() => repo.getProducts()).thenAnswer((_) async => const Right([]));

      if (getIt.isRegistered<OwnerProductsCubit>()) {
        getIt.unregister<OwnerProductsCubit>();
      }
      getIt.registerFactory<OwnerProductsCubit>(() => OwnerProductsCubit(repo));
      addTearDown(() {
        if (getIt.isRegistered<OwnerProductsCubit>()) {
          getIt.unregister<OwnerProductsCubit>();
        }
      });

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
            home: const OwnerProductsPage(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(
        scaffold.floatingActionButtonLocation,
        FloatingActionButtonLocation.startFloat,
      );
      expect(find.byType(SafeArea), findsWidgets);
    });
  });
}
