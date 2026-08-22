// شاشة سلة المشتريات لعميل متجر قطع الغيار
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart'; // 🎯 استيراد AppColors للألوان الموحدة
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_state.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/widgets/cart_item_card.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/widgets/cart_total_bar.dart';
import 'package:car_care/features/spare_parts_store/customer/shared/presentation/widgets/customer_store_bottom_nav_bar.dart';
import 'package:car_care/l10n.dart'; // 🎯 استيراد امتداد l10n للترجمة الديناميكية
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CartCubit>()..fetchCart();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.transparent, 
        appBar: CustomAppBar(title: l10n.cartPageTitle), 
        bottomNavigationBar: const CustomerStoreBottomNavBar(
          current: CustomerStoreSection.cart,
        ),
        body: ImageBackground(
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartLoaded && state.actionError != null) {
                AppSnackBar.error(context, state.actionError!);
                _cubit.clearActionError();
              }
            },
            builder: (context, state) {
              if (state is CartLoading) {
                return const AppLoadingWidget();
              }
              if (state is CartError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => _cubit.fetchCart(),
                );
              }
              if (state is CartEmpty) {
                return RefreshIndicator(
                  onRefresh: _cubit.fetchCart,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [EmptyStateWidget()],
                  ),
                );
              }
              if (state is CartLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _cubit.fetchCart,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            12.h,
                            16.w,
                            12.h,
                          ),
                          itemCount: state.cart.items.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = state.cart.items[index];
                            return CartItemCard(
                              item: item,
                              isQuantityUpdating: state
                                  .quantityUpdatingItemIds
                                  .contains(item.id),
                              isDeleting: state.deletingItemIds.contains(
                                item.id,
                              ),
                              onQuantityChanged: (quantity) =>
                                  _cubit.updateQuantity(item.id, quantity),
                              onDelete: () => _cubit.removeItem(item.id),
                            );
                          },
                        ),
                      ),
                    ),
                    CartTotalBar(
                      total: state.cart.total,
                      onCheckout: () => context.push(
                        Routes.customerCheckout,
                        extra: {
                          'cartCubit': _cubit,
                          'total': state.cart.total,
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
