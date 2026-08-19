import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order/provider_order_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProviderOrderPage extends StatelessWidget {
  const ProviderOrderPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
    
      body: ImageBackground(
        child: BlocBuilder<FuelProviderOrderCubit, FuelProviderOrderState>(
          builder: (context, state) {
            if (state is FuelProviderOrderLoading) {
              return const Center(child: AppLoadingWidget());
            }
            if (state is FuelProviderOrderError) {
                AppSnackBar.error(context, state.message);
            }
            if (state is FuelProviderOrdersListLoaded) {
              if (state.orders.isEmpty) {
          return const Center(child:  EmptyStateWidget() );
              }
              return ProviderOrderBody(
                orders: state.orders,
                 onViewDetails: (order) async {
                  final changed = await context.pushNamed<bool>(
                    'providerOrderDetailsPage',
                    pathParameters: {'id': order.id.toString()},
                  );
                  if (changed == true && context.mounted) {
                    context.read<FuelProviderOrderCubit>().getMyOrders();
                  }
                },
              );
            }
            return const EmptyStateWidget();
          },
        ),
      ),
    );
  }
}
