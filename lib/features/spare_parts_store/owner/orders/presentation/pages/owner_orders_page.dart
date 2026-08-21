// شاشة قائمة طلبات المتجر للمالك.
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart'; // 🎯 استيراد AppColors للألوان الموحدة
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_orders/owner_orders_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/cubit/owner_orders/owner_orders_state.dart';
import 'package:car_care/features/spare_parts_store/owner/orders/presentation/widgets/owner_order_card.dart';
import 'package:car_care/l10n.dart'; // 🎯 استيراد امتداد l10n للترجمة الديناميكية
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OwnerOrdersPage extends StatefulWidget {
  const OwnerOrdersPage({super.key});

  @override
  State<OwnerOrdersPage> createState() => _OwnerOrdersPageState();
}

class _OwnerOrdersPageState extends State<OwnerOrdersPage> {
  late final OwnerOrdersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OwnerOrdersCubit>()..fetchOrders();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; // 🎯 جلب كائن الترجمة داخل الواجهة

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.transparent, // 🎯 الاعتماد على AppColors بدلاً من الألوان الثابتة
        appBar: CustomAppBar(title: l10n.shopOrdersPageTitle), // 🎯 "طلبات المتجر" مترجم ديناميكياً
        body: ImageBackground(
          child: BlocBuilder<OwnerOrdersCubit, OwnerOrdersState>(
            builder: (context, state) {
              if (state is OwnerOrdersLoading) {
                return const AppLoadingWidget();
              }
              if (state is OwnerOrdersError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: _cubit.fetchOrders,
                );
              }
              if (state is OwnerOrdersEmpty) {
                return RefreshIndicator(
                  onRefresh: _cubit.fetchOrders,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [EmptyStateWidget()],
                  ),
                );
              }
              if (state is OwnerOrdersLoaded) {
                return RefreshIndicator(
                  onRefresh: _cubit.fetchOrders,
                  color: AppColors.primary, // 🎯 تأمين لون التحديث من الكلاس الموحد
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                    itemCount: state.orders.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OwnerOrderCard(
                        order: order,
                        onTap: () async {
                          final result = await context.push(
                            Routes.ownerOrderDetailsPath(order.id),
                          );
                          if (mounted && result == true) {
                            _cubit.fetchOrders();
                          }
                        },
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
    );
  }
}
