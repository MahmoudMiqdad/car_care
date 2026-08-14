import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_state.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_order_details/fuel_order_details_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelOrderDetailsPage extends StatelessWidget {
  const FuelOrderDetailsPage({super.key, required this.order});

  final UserFuelOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.fuelOrderDetailsTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.safePopOrGo(Routes.fuelorderslist),
        ),
        body: BlocListener<UserFuelCubit, UserFuelState>(
          listener: (context, state) {
            if (state is UserFuelOrderCancelled) {
              AppSnackBar.success (context,"تم إلغاء الطلب");
              context.safePopOrGo(Routes.fuelorderslist, result: true);
            }
            if (state is UserFuelError) {
               AppSnackBar.error(context, state.message);
            }
          },
          child: ImageBackground(
            child: FuelOrderDetailsBody(
              order: order,
              onCancel: (reason) {
                if (order.id != null) {
                  context.read<UserFuelCubit>().cancelOrder(order.id!, reason);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}