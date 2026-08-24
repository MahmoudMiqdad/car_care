import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_entity.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/domain/entities/order_item_entity.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_order_details/owner_order_details_state.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/widgets/owner_order_actions_section.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/widgets/reject_order_bottom_sheet.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/order_status_badge.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OwnerOrderDetailsPage extends StatefulWidget {
  const OwnerOrderDetailsPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<OwnerOrderDetailsPage> createState() => _OwnerOrderDetailsPageState();
}

class _OwnerOrderDetailsPageState extends State<OwnerOrderDetailsPage> {
  late final OwnerOrderDetailsCubit _cubit;

  bool _mutated = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OwnerOrderDetailsCubit>()..fetchOrderDetails(widget.orderId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _handleReject() async {
    final reason = await RejectOrderBottomSheet.show(context);
    if (reason == null || !mounted) return;
    _cubit.rejectOrder(widget.orderId, reason);
  }

  @override
  Widget build(BuildContext context) {
    final string = context.l10n;
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.safePopOrGo(Routes.ownerOrders, result: _mutated);
      },
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: string.orderDetailsTitle,
            onBackTapped: () =>
                context.safePopOrGo(Routes.ownerOrders, result: _mutated),
          ),
          body: ImageBackground(
            child: BlocConsumer<OwnerOrderDetailsCubit, OwnerOrderDetailsState>(
              listener: (context, state) {
                if (state is! OwnerOrderDetailsLoaded) return;
                if (state.successMessage != null) {
                  AppSnackBar.success(context, state.successMessage!);
                  _cubit.clearSuccessMessage();
                  setState(() => _mutated = true);
                }
                if (state.actionError != null) {
                  AppSnackBar.error(context, state.actionError!);
                  _cubit.clearActionError();
                }
              },
              builder: (context, state) {
                if (state is OwnerOrderDetailsLoading) {
                  return const AppLoadingWidget();
                }
                if (state is OwnerOrderDetailsError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () => _cubit.fetchOrderDetails(widget.orderId),
                  );
                }
                if (state is OwnerOrderDetailsLoaded) {
                  return _buildContent(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(OwnerOrderDetailsLoaded state) {
    final order = state.order;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderCard(order: order),
          SizedBox(height: 12.h),
          _ItemsCard(items: order.items),
          SizedBox(height: 12.h),
          _TotalCard(totalPrice: order.totalPrice),
          if (order.deliveryAddressNote != null ||
              order.customerLatitude != null) ...[
            SizedBox(height: 12.h),
            _DeliveryCard(order: order),
          ],
          SizedBox(height: 20.h),
          OwnerOrderActionsSection(
            status: order.status,
            activeAction: state.activeAction,
            onAccept: () => _cubit.acceptOrder(widget.orderId),
            onReject: _handleReject,
            onStartProcessing: () => _cubit.startProcessing(widget.orderId),
            onStartDelivery: () => _cubit.startDelivery(widget.orderId),
            onConfirmDelivered: () => _cubit.confirmDelivered(widget.orderId),
            onShareLocation: () => context.push(
              Routes.ownerShareLocationPath(widget.orderId),
              extra: {
                'customerLat': order.customerLatitude,
                'customerLng': order.customerLongitude,
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final string = context.l10n;
    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${string.orderNumberLabel}#${order.id}',
                  style: context.textTheme.labelLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (order.createdAt != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    order.createdAt!.toLocal().toString().substring(0, 10),
                    style: context.textTheme.labelSmall!.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          OrderStatusBadge(status: order.status, label: order.statusText),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final string = context.l10n;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            string.productsLabel,
            style: context.textTheme.labelMedium!.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          ...items.map((item) => _ItemRow(item: item)),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${item.quantity} × ${item.price.toStringAsFixed(0)} ل.س',
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.subtotal.toStringAsFixed(0)} ل.س',
            style: context.textTheme.labelSmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
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
    final string = context.l10n;

    return _Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الإجمالي',
            style: context.textTheme.labelMedium!.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${totalPrice.toStringAsFixed(0)} ل.س',
            style: context.textTheme.labelLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات التوصيل',
            style: context.textTheme.labelMedium!.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (order.deliveryAddressNote != null) ...[
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    order.deliveryAddressNote!,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (order.customerLatitude != null &&
              order.customerLongitude != null) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.my_location_outlined,
                  size: 14.sp,
                  color: AppColors.textSecondary(context),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${order.customerLatitude!.toStringAsFixed(5)}, ${order.customerLongitude!.toStringAsFixed(5)}',
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary(context),
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

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
