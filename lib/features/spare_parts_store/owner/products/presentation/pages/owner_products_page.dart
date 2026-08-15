// شاشة قائمة منتجات المتجر للمالك — عرض/إضافة/تعديل جزئي (سعر ومخزون)/حذف.
// الوصول لهذه الصفحة نفسها مقصور فعليًا على صاحب متجر Approved عبر بوابة
// صفحة More (لا تتكرر هنا نفس عملية جلب حالة المتجر تفاديًا لطلب مكرر).
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/products/domain/entities/product_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_state.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/pages/owner_add_product_page.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/widgets/owner_product_card.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/widgets/owner_product_edit_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerProductsPage extends StatefulWidget {
  const OwnerProductsPage({super.key});

  @override
  State<OwnerProductsPage> createState() => _OwnerProductsPageState();
}

class _OwnerProductsPageState extends State<OwnerProductsPage> {
  late final OwnerProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OwnerProductsCubit>()..fetchProducts();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _handleEdit(ProductEntity product) async {
    final result = await OwnerProductEditSheet.show(context, product: product);
    if (result == null || !mounted) return;
    _cubit.updateProduct(
      product.id,
      price: result.price,
      stockQuantity: result.stockQuantity,
    );
  }

  Future<void> _handleDelete(int productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) _cubit.deleteProduct(productId);
  }

  void _openAddProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const OwnerAddProductPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'منتجات المتجر'),
          // start = يمين تحت اتجاه RTL الحالي، أي أسفل اليمين فعليًا.
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h, right: 16.w),
              child: FloatingAddButton(onTap: _openAddProduct),
            ),
          ),
          body: ImageBackground(
            child: BlocConsumer<OwnerProductsCubit, OwnerProductsState>(
              listener: (context, state) {
                if (state is OwnerProductsLoaded && state.actionError != null) {
                  AppSnackBar.error(context, state.actionError!);
                  _cubit.clearActionError();
                }
              },
              builder: (context, state) {
                if (state is OwnerProductsLoading) {
                  return const AppLoadingWidget();
                }
                if (state is OwnerProductsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: _cubit.fetchProducts,
                  );
                }
                if (state is OwnerProductsEmpty) {
                  return RefreshIndicator(
                    onRefresh: _cubit.fetchProducts,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [EmptyStateWidget()],
                    ),
                  );
                }
                if (state is OwnerProductsLoaded) {
                  return RefreshIndicator(
                    onRefresh: _cubit.fetchProducts,
                    color: Theme.of(context).primaryColor,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                      itemCount: state.products.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return OwnerProductCard(
                          product: product,
                          isSaving: state.savingId == product.id,
                          isDeleting: state.deletingIds.contains(product.id),
                          onEdit: () => _handleEdit(product),
                          onDelete: () => _handleDelete(product.id),
                        );
                      },
                    ),
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
