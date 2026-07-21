// شاشة تفاصيل طلب قطع الغيار لعميل
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/widgets/cancel_order_bottom_sheet.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_item_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/order_details/order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomerOrderDetailsPage extends StatefulWidget {
  const CustomerOrderDetailsPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<CustomerOrderDetailsPage> createState() =>
      _CustomerOrderDetailsPageState();
}

class _CustomerOrderDetailsPageState extends State<CustomerOrderDetailsPage> {
  late final OrderDetailsCubit _cubit;

  // Staggered entrance flags for each card section
  bool _s0 = false, _s1 = false, _s2 = false, _s3 = false, _s4 = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OrderDetailsCubit>()..fetchOrderDetails(widget.orderId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _triggerEntrance() {
    Future.delayed(const Duration(milliseconds: 50),
        () { if (mounted) setState(() => _s0 = true); });
    Future.delayed(const Duration(milliseconds: 150),
        () { if (mounted) setState(() => _s1 = true); });
    Future.delayed(const Duration(milliseconds: 240),
        () { if (mounted) setState(() => _s2 = true); });
    Future.delayed(const Duration(milliseconds: 320),
        () { if (mounted) setState(() => _s3 = true); });
    Future.delayed(const Duration(milliseconds: 400),
        () { if (mounted) setState(() => _s4 = true); });
  }

  Widget _fadeSlide({required bool visible, required Widget child}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOut,
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
        offset: visible ? Offset.zero : const Offset(0, 0.08),
        child: child,
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
          appBar: const CustomAppBar(title: 'تفاصيل الطلب'),
          body: ImageBackground(
            child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
              listener: (context, state) {
                if (state is OrderDetailsLoaded) {
                  _triggerEntrance();
                  if (state.cancelError != null) {
                    AppSnackBar.error(context, state.cancelError!);
                    _cubit.clearCancelError();
                  }
                }
              },
              builder: (context, state) {
                if (state is OrderDetailsLoading) return const AppLoadingWidget();
                if (state is OrderDetailsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => _cubit.fetchOrderDetails(widget.orderId),
                  );
                }
                if (state is OrderDetailsLoaded) return _buildLoaded(state);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCancel(int orderId) async {
    final reason = await CancelOrderBottomSheet.show(context);
    if (reason == null || !mounted) return;
    _cubit.cancelOrder(orderId, reason);
  }

  Widget _buildLoaded(OrderDetailsLoaded state) {
    final order = state.order;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fadeSlide(visible: _s0, child: _HeroHeaderCard(order: order)),
          SizedBox(height: 12.h),
          _fadeSlide(visible: _s1, child: _ShopCard(order: order)),
          SizedBox(height: 12.h),
          _fadeSlide(visible: _s2, child: _ItemsList(items: order.items)),
          SizedBox(height: 12.h),
          _fadeSlide(visible: _s3, child: _DeliveryCard(order: order)),
          SizedBox(height: 12.h),
          _fadeSlide(visible: _s4, child: _TotalCard(totalPrice: order.totalPrice)),
          if (order.status == 'out_for_delivery') ...[
            SizedBox(height: 16.h),
            _fadeSlide(
              visible: _s4,
              child: _TrackDeliveryButton(
                onTrack: () => context.push(
                  Routes.customerTrackDeliveryPath(order.id),
                  extra: {
                    'customerLat': order.customerLatitude,
                    'customerLng': order.customerLongitude,
                  },
                ),
              ),
            ),
          ],
          if (order.canCancel) ...[
            SizedBox(height: 16.h),
            _fadeSlide(
              visible: _s4,
              child: _CancelButton(
                isCancelling: state.isCancelling,
                onCancel: () => _handleCancel(order.id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// كارد رئيسي بخلفية primary يعطي تأثير Hero واضح لأول عنصر في الصفحة
class _HeroHeaderCard extends StatelessWidget {
  const _HeroHeaderCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب رقم',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '#${order.id}',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.5, end: 1.0),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.elasticOut,
                    builder: (_, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      order.statusText,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),   // close Container (child of TweenAnimationBuilder)
                  ),   // close TweenAnimationBuilder
                  if (order.canCancel) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'قابل للإلغاء',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (order.createdAt != null) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 13.sp,
                  color: AppColors.white.withOpacity(0.6),
                ),
                SizedBox(width: 4.w),
                Text(
                  order.createdAt!.toLocal().toString().substring(0, 16),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final shop = order.shop;
    return _SectionCard(
      icon: Icons.storefront_outlined,
      title: 'المتجر',
      color: AppColors.primary,
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.store_outlined,
            text: shop.name,
            textStyle: AppTypography.labelLarge.copyWith(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (shop.city != null)
            _DetailRow(icon: Icons.location_city_outlined, text: shop.city!),
          if (shop.phone != null)
            _DetailRow(icon: Icons.phone_outlined, text: shop.phone!),
        ],
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'المنتجات (${items.length})',
      color: AppColors.primary,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _OrderItemRow(item: items[i]),
            if (i < items.length - 1)
              Divider(color: AppColors.lightBorder, height: 16.h),
          ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            item.product.name,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '×${item.quantity}',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '${item.subtotal.toStringAsFixed(0)} ل.س',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.local_shipping_outlined,
      title: 'التوصيل',
      color: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (order.deliveryAddressNote != null)
            Text(
              order.deliveryAddressNote!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
          if (order.customerLatitude != null && order.customerLongitude != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 13.sp, color: AppColors.lightTextSecondary),
                  SizedBox(width: 4.w),
                  Text(
                    '${order.customerLatitude!.toStringAsFixed(5)}, '
                    '${order.customerLongitude!.toStringAsFixed(5)}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.lightTextSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.totalPrice});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الإجمالي الكلي',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.lightTextSecondary,
            ),
          ),
          Text(
            '${totalPrice.toStringAsFixed(0)} ل.س',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackDeliveryButton extends StatelessWidget {
  const _TrackDeliveryButton({required this.onTrack});

  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTrack,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.location_on_outlined, size: 18.sp),
        label: Text(
          'تتبع التوصيل',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// قالب موحّد للكروت الداخلية: عنوان + أيقونة + محتوى — يقلّل تكرار الكود ويوحّد المظهر
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                title,
                style: AppTypography.labelLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
    this.textStyle,
  });

  final IconData icon;
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15.sp, color: AppColors.lightTextSecondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: textStyle ??
                  AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.isCancelling, required this.onCancel});

  final bool isCancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isCancelling
          ? Center(
              child: SizedBox(
                width: 24.sp,
                height: 24.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.error,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: Icon(Icons.cancel_outlined, size: 18.sp),
              label: Text(
                'إلغاء الطلب',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}
