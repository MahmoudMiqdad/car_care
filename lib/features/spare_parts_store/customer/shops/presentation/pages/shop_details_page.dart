// شاشة معلومات متجر قطع غيار محدّد (Read-only)
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/domain/entities/shop_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/cubit/shop_details/shop_details_state.dart';
import 'package:car_care/features/spare_parts_store/customer/shops/presentation/widgets/shop_info_chips.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_attribute_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopDetailsPage extends StatefulWidget {
  const ShopDetailsPage({super.key, required this.shopId});

  final int shopId;

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  late final ShopDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ShopDetailsCubit>()..fetchShopDetails(widget.shopId);
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
          appBar: const CustomAppBar(title: 'معلومات المتجر'),
          body: ImageBackground(
            child: BlocBuilder<ShopDetailsCubit, ShopDetailsState>(
              builder: (context, state) {
                if (state is ShopDetailsLoading) {
                  return const AppLoadingWidget();
                }
                if (state is ShopDetailsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => _cubit.fetchShopDetails(widget.shopId),
                  );
                }
                if (state is ShopDetailsLoaded) {
                  return _buildLoaded(context, state.shop);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ShopEntity shop) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopInfoChips(
            title: 'نوع النشاط',
            values: shop.businessTypes,
            titleIcon: Icons.storefront_outlined,
            type: StoreAttributeType.businessType,
          ),
          if (shop.businessTypes.isNotEmpty) SizedBox(height: 18.h),
          ShopInfoChips(
            title: 'ماركات السيارات',
            values: shop.carBrands,
            titleIcon: Icons.directions_car_outlined,
            type: StoreAttributeType.carBrand,
          ),
          if (shop.carBrands.isNotEmpty) SizedBox(height: 18.h),
          ShopInfoChips(
            title: 'فئات القطع',
            values: shop.partCategories,
            titleIcon: Icons.build_outlined,
            type: StoreAttributeType.partCategory,
          ),
        ],
      ),
    );
  }
}
