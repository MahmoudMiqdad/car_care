import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_state.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_orders_list/fuel_order_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FuelOrdersListPage extends StatefulWidget {
  const FuelOrdersListPage({super.key});

  @override
  State<FuelOrdersListPage> createState() => _FuelOrdersListPageState();
}

class _FuelOrdersListPageState extends State<FuelOrdersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserFuelCubit>().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        
        backgroundColor: AppColors.lightScaffold,
        floatingActionButton: Padding(
  padding: EdgeInsets.only(bottom: 16.h, left: 16.w),
  child: FloatingAddButton(
    onTap: () async {
      final refreshNeeded = await context.push<bool>(Routes.add_user_fuel);
      if (refreshNeeded == true && context.mounted) {
        context.read<UserFuelCubit>().getAllOrders();
      }
    },
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CustomAppBar(
          title: l10n.fuelOrdersListTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.safePopOrGo(Routes.home),
        ),
        body: ImageBackground(
          child: BlocBuilder<UserFuelCubit, UserFuelState>(
            builder: (context, state) {
              if (state is UserFuelLoading) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is UserFuelError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () =>
                            context.read<UserFuelCubit>().getAllOrders(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is UserFuelOrdersLoaded) {
                if (state.orders.isEmpty) {
                  return const Center(child: Text('لا توجد طلبات'));
                }

                return RefreshIndicator(
                onRefresh: () async {
                context.read<UserFuelCubit>().getAllOrders();
              },

                  child: SafeArea(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        AppConstants.pageHorizontal,
                        30.h,
                        AppConstants.pageHorizontal,
                        16.h,
                      ),
                      itemCount: state.orders.length,
                      separatorBuilder: (_, _) => SizedBox(height: 16.h),
                      itemBuilder: (_, index) {
                        final order = state.orders[index];
                        return FuelOrderCard(
                          order: order,
                          onTap: () async {
                            final refreshNeeded = await context.push<bool>(
                              Routes.fuel_order_details,
                              extra: order, // ← Entity مباشرة
                            );
                            if (refreshNeeded == true && context.mounted) {
                              context.read<UserFuelCubit>().getAllOrders();
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}