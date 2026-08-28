import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
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

const String _kAllStatusValue = '__all__';

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

  Widget _buildStatusTabs(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      StatusFilterTabItem(value: _kAllStatusValue, label: l10n.orderStatusAll),
      StatusFilterTabItem(value: 'pending', label: l10n.orderStatusPending),
      StatusFilterTabItem(value: 'accepted', label: l10n.orderStatusAccepted),
      StatusFilterTabItem(
        value: 'processing',
        label: l10n.orderStatusProcessing,
      ),
      StatusFilterTabItem(
        value: 'out_for_delivery',
        label: l10n.orderStatusOutForDelivery,
      ),
      StatusFilterTabItem(value: 'delivered', label: l10n.orderStatusDelivered),
      StatusFilterTabItem(value: 'rejected', label: l10n.orderStatusRejected),
      StatusFilterTabItem(value: 'cancelled', label: l10n.orderStatusCancelled),
    ];

    return StatusFilterTabs<String>(
      items: items,
      selected: _activeStatus ?? _kAllStatusValue,
      onChanged: (value) =>
          _onStatusChanged(value == _kAllStatusValue ? null : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: l10n.allRequestsTitle),
        bottomNavigationBar: const CustomerStoreBottomNavBar(
          current: CustomerStoreSection.orders,
        ),
        body: ImageBackground(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                child: _buildStatusTabs(context),
              ),
              Expanded(
                child: BlocConsumer<CustomerOrdersCubit, CustomerOrdersState>(
                  listener: (context, state) {
                    if (state is CustomerOrdersLoaded &&
                        state.actionError != null) {
                      AppSnackBar.error(context, localizeErrorMessage(context, state.actionError));
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
