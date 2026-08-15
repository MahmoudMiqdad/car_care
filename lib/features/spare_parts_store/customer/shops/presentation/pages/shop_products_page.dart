// واجهة المتجر (Storefront): رأس مختصر + شبكة منتجات المتجر
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/product_card.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_state.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_products/shop_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_products/shop_products_state.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ShopProductsPage extends StatefulWidget {
  const ShopProductsPage({super.key, required this.shopId, this.initialShop});

  final int shopId;

  /// اختياري: يُغني عن طلب تفاصيل إضافي إن توفر مسبقًا. غيابه يستخدم Fallback.
  final ShopEntity? initialShop;

  @override
  State<ShopProductsPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends State<ShopProductsPage> {
  late final ShopProductsCubit _productsCubit;
  ShopDetailsCubit? _detailsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = getIt<ShopProductsCubit>()
      ..fetchShopProducts(widget.shopId);
    if (widget.initialShop == null) {
      _detailsCubit = getIt<ShopDetailsCubit>()
        ..fetchShopDetails(widget.shopId);
    }
  }

  @override
  void dispose() {
    _productsCubit.close();
    _detailsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _productsCubit),
          if (_detailsCubit != null) BlocProvider.value(value: _detailsCubit!),
        ],
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'واجهة المتجر'),
          body: ImageBackground(
            child: Column(
              children: [
                _Header(
                  shopId: widget.shopId,
                  initialShop: widget.initialShop,
                  detailsCubit: _detailsCubit,
                ),
                Expanded(
                  child: BlocBuilder<ShopProductsCubit, ShopProductsState>(
                    builder: (context, state) {
                      if (state is ShopProductsLoading) {
                        return const AppLoadingWidget();
                      }
                      if (state is ShopProductsError) {
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () =>
                              _productsCubit.fetchShopProducts(widget.shopId),
                        );
                      }
                      if (state is ShopProductsEmpty) {
                        return RefreshIndicator(
                          onRefresh: () =>
                              _productsCubit.fetchShopProducts(widget.shopId),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [EmptyStateWidget()],
                          ),
                        );
                      }
                      if (state is ShopProductsLoaded) {
                        return RefreshIndicator(
                          onRefresh: () =>
                              _productsCubit.fetchShopProducts(widget.shopId),
                          child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.all(16.w),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                  Routes.customerProductDetailsPreviewPath(
                                    product.id,
                                  ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.shopId,
    required this.initialShop,
    required this.detailsCubit,
  });

  final int shopId;
  final ShopEntity? initialShop;
  final ShopDetailsCubit? detailsCubit;

  @override
  Widget build(BuildContext context) {
    if (initialShop != null) {
      return _HeaderContent(shop: initialShop!, shopId: shopId);
    }
    return BlocBuilder<ShopDetailsCubit, ShopDetailsState>(
      bloc: detailsCubit,
      builder: (context, state) {
        if (state is ShopDetailsLoaded) {
          return _HeaderContent(shop: state.shop, shopId: shopId);
        }
        if (state is ShopDetailsError) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 60.h,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({required this.shop, required this.shopId});

  final ShopEntity shop;
  final int shopId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StoreStatusBadge(isActive: shop.isActive),
            ],
          ),
          if (shop.city != null) ...[
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14.sp,
                  color: AppColors.lightTextSecondary,
                ),
                SizedBox(width: 3.w),
                Text(
                  shop.city!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () =>
                  context.push(Routes.customerShopDetailsPath(shopId)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'معلومات المتجر',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
