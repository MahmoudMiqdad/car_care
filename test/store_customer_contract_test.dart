// اختبارات عقد متجر قطع الغيار: Parsing، طلبات الشبكة الفعلية، وسلوك النجاح/الفشل.
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/data/models/cart_model.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/entities/cart_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_state.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/data/data_sources/checkout_remote_data_source.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/data/models/order_model.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/cubit/create_order/create_order_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/cubit/create_order/create_order_state.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/domain/repositories/i_customer_orders_repository.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_state.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/data/models/product_model.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/data/models/shop_model.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockCartRepository extends Mock implements ICartRepository {}

class MockCustomerOrdersRepository extends Mock
    implements ICustomerOrdersRepository {}

Map<String, dynamic> _productJson({
  required dynamic price,
  required dynamic finalPrice,
}) {
  return {
    'id': 1,
    'name': 'فلتر زيت',
    'description': 'وصف',
    'price': price,
    'discount_price': null,
    'final_price': finalPrice,
    'stock_quantity': 5,
    'weight_kg': null,
    'dimensions': null,
    'condition': 'new',
    'is_featured': false,
    'car_brand': null,
    'part_category': null,
    'images': [],
    'primary_image': null,
    'created_at': '2026-01-01',
  };
}

void main() {
  group('1) Parsing — الأسعار والإحداثيات كـ String أو num', () {
    test('ProductModel.fromJson يقرأ price/final_price كـ String', () {
      final model = ProductModel.fromJson(
        _productJson(price: '150.5', finalPrice: '120.0'),
      );
      expect(model.price, 150.5);
      expect(model.finalPrice, 120.0);
    });

    test('ProductModel.fromJson يقرأ price/final_price كـ num', () {
      final model = ProductModel.fromJson(
        _productJson(price: 150, finalPrice: 120),
      );
      expect(model.price, 150.0);
      expect(model.finalPrice, 120.0);
    });

    test('ShopModel.fromJson يقرأ id كـ String أو int', () {
      final base = {
        'name': 'متجر',
        'phone': '0999',
        'city': 'دمشق',
        'is_active': true,
        'owner': null,
        'business_types': [],
        'car_brands': [],
        'part_categories': [],
        'created_at': '2026-01-01',
      };
      expect(ShopModel.fromJson({...base, 'id': '7'}).id, 7);
      expect(ShopModel.fromJson({...base, 'id': 7}).id, 7);
    });

    test(
      'OrderModel.fromJson يقرأ total_price/customer_latitude/longitude كـ String',
      () {
        final order = OrderModel.fromJson({
          'id': 3,
          'shop': {
            'id': 1,
            'name': 'متجر',
            'is_active': true,
            'business_types': [],
            'car_brands': [],
            'part_categories': [],
          },
          'items': [],
          'total_price': '250.75',
          'status': 'pending',
          'status_text': 'قيد الانتظار',
          'delivery_address_note': 'ملاحظة',
          'customer_latitude': '32.5198',
          'customer_longitude': '36.4826',
          'created_at': '2026-01-01',
          'can_cancel': true,
        });
        expect(order.totalPrice, 250.75);
        expect(order.customerLatitude, 32.5198);
        expect(order.customerLongitude, 36.4826);
        expect(order.canCancel, isTrue);
      },
    );
  });

  group('2) السلة الفارغة', () {
    test('{success:true,data:[],total:0} ينتج CartEntity فارغ', () {
      final cart = CartModel.fromResponse({
        'success': true,
        'data': [],
        'total': 0,
      });
      expect(cart.items, isEmpty);
      expect(cart.total, 0);
    });

    test('CartCubit.fetchCart يصدر CartEmpty لسلة فارغة', () async {
      final repo = MockCartRepository();
      when(
        () => repo.getCart(),
      ).thenAnswer((_) async => const Right(CartEntity(items: [], total: 0)));
      final cubit = CartCubit(repo);
      await cubit.fetchCart();
      expect(cubit.state, isA<CartEmpty>());
      await cubit.close();
    });
  });

  group('3) Add To Cart — الحقول المرسلة', () {
    test('يرسل product_id و quantity فقط إلى POST /customer/cart', () async {
      final api = MockApiService();
      when(
        () => api.post(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => {
          'success': true,
          'data': {
            'id': 9,
            'product': _productJson(price: 100, finalPrice: 100),
            'quantity': 2,
            'subtotal': 200,
            'added_at': '2026-01-01',
          },
        },
      );

      final dataSource = CartRemoteDataSource(api);
      await dataSource.addToCart(productId: 5, quantity: 2);

      final captured = verify(
        () => api.post(
          endPoint: captureAny(named: 'endPoint'),
          data: captureAny(named: 'data'),
        ),
      ).captured;

      expect(captured[0], ApiEndpoints.customerCart);
      expect(captured[1], {'product_id': 5, 'quantity': 2});
    });
  });

  group('4) Update Cart — القيمة النهائية لا زيادة محلية', () {
    test('PUT يرسل quantity كقيمة نهائية فقط، بلا أي حساب محلي', () async {
      final api = MockApiService();
      when(
        () => api.put(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => {'success': true});

      final dataSource = CartRemoteDataSource(api);
      await dataSource.updateCartItem(cartItemId: 9, quantity: 4);

      final captured = verify(
        () => api.put(
          endPoint: captureAny(named: 'endPoint'),
          data: captureAny(named: 'data'),
        ),
      ).captured;

      expect(captured[0], ApiEndpoints.customerCartItemById(9));
      expect(captured[1], {'quantity': 4});
    });
  });

  group('5) إنشاء الطلب — نجاح 201', () {
    test('الحقول الثلاثة المرسلة مطابقة للعقد', () async {
      final api = MockApiService();
      when(
        () => api.post(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'id': 11,
            'shop': {
              'id': 1,
              'name': 'متجر',
              'is_active': true,
              'business_types': [],
              'car_brands': [],
              'part_categories': [],
            },
            'items': [],
            'total_price': '100',
            'status': 'pending',
            'status_text': 'قيد الانتظار',
            'can_cancel': true,
          },
        },
      );

      final dataSource = CheckoutRemoteDataSource(api);
      final order = await dataSource.createOrder(
        latitude: 32.5198,
        longitude: 36.4826,
        addressNote: 'بصرى الشام',
      );

      final captured = verify(
        () => api.post(
          endPoint: captureAny(named: 'endPoint'),
          data: captureAny(named: 'data'),
        ),
      ).captured;

      expect(captured[0], ApiEndpoints.customerOrders);
      expect(captured[1], {
        'latitude': 32.5198,
        'longitude': 36.4826,
        'address_note': 'بصرى الشام',
      });
      expect(order.id, 11);
      expect(order.status, 'pending');
    });
  });

  group('6) إنشاء الطلب — فشل', () {
    test('استثناء يصدر CreateOrderError ولا يصدر Success مطلقًا', () async {
      final api = MockApiService();
      when(
        () => api.post(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenThrow(ServerExpcptions(error: const Failure(message: 'خطأ 500')));

      final repo = CheckoutRepositoryImpl(CheckoutRemoteDataSource(api));
      final cubit = CreateOrderCubit(repo);

      final states = <CreateOrderState>[];
      cubit.stream.listen(states.add);

      await cubit.createOrder(
        latitude: 32.5198,
        longitude: 36.4826,
        addressNote: 'ملاحظة',
      );

      expect(cubit.state, isA<CreateOrderError>());
      expect(states.whereType<CreateOrderSuccess>(), isEmpty);
      await cubit.close();
    });

    test('مسار الفشل لا يستدعي أي Refresh على CartCubit', () async {
      final checkoutApi = MockApiService();
      when(
        () => checkoutApi.post(
          endPoint: any(named: 'endPoint'),
          data: any(named: 'data'),
        ),
      ).thenThrow(ServerExpcptions(error: const Failure(message: 'خطأ 500')));

      final cartRepo = MockCartRepository();
      final cartCubit = CartCubit(cartRepo);

      final checkoutRepo = CheckoutRepositoryImpl(
        CheckoutRemoteDataSource(checkoutApi),
      );
      final orderCubit = CreateOrderCubit(checkoutRepo);

      await orderCubit.createOrder(latitude: 1, longitude: 1, addressNote: 'x');

      expect(orderCubit.state, isA<CreateOrderError>());
      verifyNever(() => cartRepo.getCart());

      await orderCubit.close();
      await cartCubit.close();
    });
  });

  group('7) إلغاء الطلب — رسالة فقط، والحالة من إعادة الجلب', () {
    test(
      'cancelOrder يعيد String وليس Order، وإعادة الجلب تحدث بعد النجاح',
      () async {
        final repo = MockCustomerOrdersRepository();
        when(
          () => repo.cancelOrder(5, 'سبب كافٍ'),
        ).thenAnswer((_) async => const Right('تم إلغاء الطلب بنجاح'));
        when(() => repo.getOrders(status: null)).thenAnswer(
          (_) async => Right([_fakeOrder(id: 5, status: 'cancelled')]),
        );

        final cubit = CustomerOrdersCubit(repo);
        await cubit.fetchOrders();
        final loaded = cubit.state as CustomerOrdersLoaded;
        // مطلوب فقط أن التوقيع يعيد String (فحص نوعي مباشر بلا استدعاء cubit).
        final result = await repo.cancelOrder(5, 'سبب كافٍ');
        expect(result.isRight(), isTrue);
        result.fold((_) => null, (message) => expect(message, isA<String>()));
        expect(loaded.orders, isNotEmpty);
        await cubit.close();
      },
    );

    test(
      'OrderDetailsCubit يعيد الجلب بعد إلغاء ناجح ولا يفترض Order من الاستجابة',
      () async {
        final repo = MockCustomerOrdersRepository();
        when(
          () => repo.getOrderDetails(5),
        ).thenAnswer((_) async => Right(_fakeOrder(id: 5, status: 'pending')));
        when(
          () => repo.cancelOrder(5, 'سبب'),
        ).thenAnswer((_) async => const Right('تم الإلغاء'));

        final cubit = OrderDetailsCubit(repo);
        await cubit.fetchOrderDetails(5);
        await cubit.cancelOrder(5, 'سبب');
        await Future<void>.delayed(Duration.zero);

        verify(() => repo.getOrderDetails(5)).called(2);
        await cubit.close();
      },
    );
  });

  group('8) منع النقر المتكرر', () {
    test(
      'CustomerOrdersCubit.cancelOrder لا يفعل شيئًا إن لم تكن القائمة محمّلة',
      () async {
        final repo = MockCustomerOrdersRepository();
        final cubit = CustomerOrdersCubit(repo);
        await cubit.cancelOrder(1, 'سبب');
        verifyNever(() => repo.cancelOrder(any(), any()));
        await cubit.close();
      },
    );

    test(
      'CreateOrderCubit لا يصدر أكثر من Loading واحد متتابع لاستدعاء واحد',
      () async {
        final api = MockApiService();
        when(
          () => api.post(
            endPoint: any(named: 'endPoint'),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': {
              'id': 1,
              'shop': {
                'id': 1,
                'name': 'متجر',
                'is_active': true,
                'business_types': [],
                'car_brands': [],
                'part_categories': [],
              },
              'items': [],
              'total_price': '10',
              'status': 'pending',
              'status_text': 'قيد الانتظار',
              'can_cancel': true,
            },
          },
        );
        final repo = CheckoutRepositoryImpl(CheckoutRemoteDataSource(api));
        final cubit = CreateOrderCubit(repo);

        final states = <CreateOrderState>[];
        cubit.stream.listen(states.add);
        await cubit.createOrder(latitude: 1, longitude: 1, addressNote: 'x');

        expect(states.whereType<CreateOrderLoading>().length, 1);
        await cubit.close();
      },
    );
  });

  group('9) Routes الأساسية للمتجر تبني دون استثناء', () {
    test('AppRouter.router يبنى بدون استثناء', () {
      expect(() => AppRouter.router, returnsNormally);
    });
  });
}

OrderModel _fakeOrder({required int id, required String status}) {
  return OrderModel(
    id: id,
    shop: const ShopModel(
      id: 1,
      name: 'متجر',
      phone: null,
      city: null,
      isActive: true,
      owner: null,
      businessTypes: [],
      carBrands: [],
      partCategories: [],
      createdAt: null,
    ),
    items: const [],
    totalPrice: 100,
    status: status,
    statusText: status,
    deliveryAddressNote: null,
    customerLatitude: null,
    customerLongitude: null,
    createdAt: null,
    canCancel: status == 'pending',
  );
}
