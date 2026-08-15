// شاشة عرض قائمة متاجر قطع الغيار مع فلترة حسب المحافظة
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/shared/presentation/widgets/customer_store_bottom_nav_bar.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shops_list/shops_list_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shops_list/shops_list_state.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/widgets/shop_card.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/widgets/shops_governorate_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ShopsListPage extends StatefulWidget {
  const ShopsListPage({super.key});

  @override
  State<ShopsListPage> createState() => _ShopsListPageState();
}

class _ShopsListPageState extends State<ShopsListPage> {
  late final ShopsListCubit _cubit;
  String? _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ShopsListCubit>()..fetchShops();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onGovernorateChanged(String? governorate) {
    if (governorate == _selectedGovernorate) return;
    setState(() => _selectedGovernorate = governorate);
    _cubit.fetchShops(city: governorate);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'متاجر قطع الغيار'),
          bottomNavigationBar: const CustomerStoreBottomNavBar(
            current: CustomerStoreSection.shops,
          ),
          body: ImageBackground(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                  child: ShopsGovernorateFilter(
                    selectedGovernorate: _selectedGovernorate,
                    onChanged: _onGovernorateChanged,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ShopsListCubit, ShopsListState>(
                    builder: (context, state) {
                      if (state is ShopsListLoading) {
                        return const AppLoadingWidget();
                      }
                      if (state is ShopsListError) {
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () =>
                              _cubit.fetchShops(city: _selectedGovernorate),
                        );
                      }
                      if (state is ShopsListEmpty) {
                        return RefreshIndicator(
                          onRefresh: () =>
                              _cubit.fetchShops(city: _selectedGovernorate),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [EmptyStateWidget()],
                          ),
                        );
                      }
                      if (state is ShopsListLoaded) {
                        return RefreshIndicator(
                          onRefresh: () =>
                              _cubit.fetchShops(city: _selectedGovernorate),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 18.h),
                            itemCount: state.shops.length,
                            separatorBuilder: (_, _) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final shop = state.shops[index];
                              return ShopCard(
                                shop: shop,
                                onVisit: () => context.push(
                                  Routes.customerShopProductsPath(shop.id),
                                  extra: shop,
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
