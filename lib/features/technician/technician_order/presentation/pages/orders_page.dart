import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/available_requests_cubit/available_requests_cubit.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/available_requests_cubit/available_requests_state.dart';
import 'package:car_care/features/technician/technician_order/presentation/widgets/technician_requests_details/orders_list_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TechnicianOrderPage extends StatelessWidget {
  const TechnicianOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvailableRequestsCubit(getIt())..fetchAvailableRequests(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
      appBar: AppBar(title: const Text("طلبات الصيانة")),
      bottomNavigationBar: HomeBottomNavBar(
        activeIndex: -1,
        onItemSelected: (index) {
          if (index == 0) {
            context.go(Routes.home);
          }
        },
      ),
      body: ImageBackground(
        child: BlocBuilder<AvailableRequestsCubit, AvailableRequestsState>(
          builder: (context, state) {
            if (state is AvailableRequestsLoading) {
              return const Center(child: AppLoadingWidget());
            }

            if (state is AvailableRequestsError) {
              return Center(child: Text(state.message));
            }

            if (state is AvailableRequestsLoaded) {
              final requests = state.requests.data;

              if (requests.isEmpty) {
                return const Center(child: Text("لا يوجد طلبات حالياً"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                context.read<AvailableRequestsCubit>().fetchAvailableRequests();
              },
                child: OrdersListView(
                  items: requests,
                
                  onOrderTap: (item) {
                    context.push(
                      Routes.orderdetails,
                      extra: item.id.toString(),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}