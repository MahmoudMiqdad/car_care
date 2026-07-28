// شاشة عرض جميع منتجات متجر قطع الغيار لعميل (الصفحة الأولى فقط حاليًا، بدون Pagination)
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/all_products/all_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/all_products/all_products_state.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late final AllProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AllProductsCubit>()..fetchAllProducts();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: 'كل المنتجات',
            actionWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                  tooltip: 'السلة',
                  onPressed: () => context.push(Routes.customerCart),
                ),
                IconButton(
                  icon: const Icon(Icons.receipt_long_outlined,
                      color: Colors.white),
                  tooltip: 'طلباتي',
                  onPressed: () => context.push(Routes.customerOrders),
                ),
              ],
            ),
          ),
          body: ImageBackground(
            child: BlocBuilder<AllProductsCubit, AllProductsState>(
              builder: (context, state) {
                if (state is AllProductsLoading) {
                  return const AppLoadingWidget();
                }
                if (state is AllProductsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => _cubit.fetchAllProducts(),
                  );
                }
                if (state is AllProductsEmpty) {
                  return const EmptyStateWidget();
                }
                if (state is AllProductsLoaded) {
                  return GridView.builder(
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      mainAxisExtent: 232.h,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                          Routes.customerProductDetailsPreviewPath(product.id),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
