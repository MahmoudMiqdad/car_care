// شاشة قائمة طلبات العميل مع فلتر الحالة وإمكانية الإلغاء
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/cubit/customer_orders/customer_orders_state.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/widgets/cancel_order_bottom_sheet.dart';
import 'package:car_care/features/spare_parts_store/customer/orders/presentation/widgets/order_card.dart';
import 'package:car_care/features/spare_parts_store/customer/shared/presentation/widgets/customer_store_bottom_nav_bar.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


class CustomerMyOrdersPage extends StatefulWidget {
  const CustomerMyOrdersPage({super.key});

  @override
  State<CustomerMyOrdersPage> createState() => _CustomerMyOrdersPageState();
}


class _CustomerMyOrdersPageState extends State<CustomerMyOrdersPage> {
  late final CustomerOrdersCubit _cubit;
  String? _activeStatus;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CustomerOrdersCubit>()..fetchOrders();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onStatusChanged(String? status) {
    if (status == _activeStatus) return;
    setState(() => _activeStatus = status);
    _cubit.fetchOrders(status: status);
  }

  Future<void> _handleCancel(int orderId) async {
    final reason = await CancelOrderBottomSheet.show(context);
    if (reason == null || !mounted) return;
    _cubit.cancelOrder(orderId, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 


    final filters = [
      (label: l10n.all, status: null),
      (label: l10n.pending, status: 'pending'),
      (label: l10n.bookingStatusAccepted, status: 'accepted'),
      (label: l10n.processingStatusLabel, status: 'processing'),
      (label: l10n.outForDeliveryStatusLabel, status: 'out_for_delivery'), 
      (label: l10n.deliveredStatusLabel, status: 'delivered'), 
      (label: l10n.rejectedStatusLabel, status: 'rejected'), 
      (label: l10n.bookingStatusCanceled, status: 'cancelled'),
    ];

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.transparent, 
        appBar: CustomAppBar(title: l10n.allRequestsTitle), 
        bottomNavigationBar: const CustomerStoreBottomNavBar(
          current: CustomerStoreSection.orders,
        ),
        body: ImageBackground(
          child: Column(
            children: [
              _StatusFilterRow(
                activeStatus: _activeStatus,
                filters: filters,
                onChanged: _onStatusChanged,
              ),
              Expanded(
                child: BlocConsumer<CustomerOrdersCubit, CustomerOrdersState>(
                  listener: (context, state) {
                    if (state is CustomerOrdersLoaded &&
                        state.actionError != null) {
                      AppSnackBar.error(context, state.actionError!);
                      _cubit.clearActionError();
                    }
                  },
                  builder: (context, state) {
                    if (state is CustomerOrdersLoading) {
                      return const AppLoadingWidget();
                    }
                    if (state is CustomerOrdersError) {
                      return ErrorStateWidget(
                        message: state.message,
                        onRetry: () =>
                            _cubit.fetchOrders(status: _activeStatus),
                      );
                    }
                    if (state is CustomerOrdersEmpty) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            _cubit.fetchOrders(status: _activeStatus),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [EmptyStateWidget()],
                        ),
                      );
                    }
                    if (state is CustomerOrdersLoaded) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            _cubit.fetchOrders(status: _activeStatus),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                          itemCount: state.orders.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final order = state.orders[index];
                            return OrderCard(
                              order: order,
                              isCancelling: state.cancellingIds.contains(
                                order.id,
                              ),
                              onTap: () async {
                                final result = await context.push(
                                  Routes.customerOrderDetailsPath(order.id),
                                );
                                if (mounted && result == true) {
                                  _cubit.fetchOrders(status: _activeStatus);
                                }
                              },
                              onCancel: () => _handleCancel(order.id),
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
    );
  }
}

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({
    required this.activeStatus,
    required this.filters,
    required this.onChanged,
  });

  final String? activeStatus;
  final List<({String label, String? status})> filters;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: isRtl, // 🎯 عكس اتجاه حركة السحب والتصفح لصفوف الفلترة تلقائياً بحسب لغة واجهة العميل
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Row(
        children: filters.map((f) {
          final isActive = activeStatus == f.status;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w), // 🎯 استخدام المسافات البرمجية الذكية للاتجاهات العالمية
            child: GestureDetector(
              onTap: () => onChanged(f.status),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border(context),
                  ),
                ),
                child: Text(
                  f.label,
                  style: context.textTheme.labelSmall!.copyWith(
                    color: isActive
                        ? AppColors.white
                        : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
