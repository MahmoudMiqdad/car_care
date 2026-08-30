import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/add_to_cart/add_to_cart_state.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/product_details/product_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/cubit/product_details/product_details_state.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/add_to_cart_bar.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/product_image_gallery.dart';
import 'package:car_care/features/spare_parts_store/customer/products/presentation/widgets/product_info_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomerProductDetailsPage extends StatefulWidget {
  const CustomerProductDetailsPage({super.key, required this.productId});

  final int productId;

  @override
  State<CustomerProductDetailsPage> createState() =>
      _CustomerProductDetailsPageState();
}

class _CustomerProductDetailsPageState
    extends State<CustomerProductDetailsPage> {
  late final ProductDetailsCubit _cubit;
  late final AddToCartCubit _addToCartCubit;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProductDetailsCubit>()..fetchProductDetails(widget.productId);
    _addToCartCubit = getIt<AddToCartCubit>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _addToCartCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: CustomAppBar(title: l10n.productDetailsTitle),
        body: ImageBackground(
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const AppLoadingWidget();
              }
              if (state is ProductDetailsError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => _cubit.fetchProductDetails(widget.productId),
                );
              }
              if (state is ProductDetailsLoaded) {
                return _buildLoaded(state.product);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is! ProductDetailsLoaded) {
              return const SizedBox.shrink();
            }
            final product = state.product;
            return BlocConsumer<AddToCartCubit, AddToCartState>(
              listener: (context, cartState) {
                if (cartState is AddToCartSuccess) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  AppSnackBar.success(
                    context,
                    l10n.productAddedToCartSuccess,
                  );
                }
                if (cartState is AddToCartError) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  AppSnackBar.error(
                    context,
                    localizeErrorMessage(context, cartState.message),
                  );
                }
              },
              builder: (context, cartState) {
                return AddToCartBar(
                  quantity: _quantity,
                  maxQuantity: product.stockQuantity,
                  totalPrice: product.finalPrice * _quantity,
                  isLoading: cartState is AddToCartLoading,
                  onQuantityChanged: (value) =>
                      setState(() => _quantity = value),
                  onAddToCart: () => _addToCartCubit.addToCart(
                    productId: product.id,
                    quantity: _quantity,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoaded(ProductEntity product) {
    final galleryImages = <String>[
      if (product.primaryImage != null) product.primaryImage!,
      ...product.images.where((url) => url != product.primaryImage),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageGallery(images: galleryImages, isNew: product.isNew),
          SizedBox(height: 16.h),
          ProductInfoSection(product: product),
        ],
      ),
    );
  }
}
