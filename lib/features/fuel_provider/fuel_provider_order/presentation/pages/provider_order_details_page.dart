import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart'; // تأكد من استيراد الـ service locator
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_accept_order_dialog.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_order_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderOrderDetailsPage extends StatelessWidget {
  const ProviderOrderDetailsPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FuelProviderOrderCubit>()..getOrder(id),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            // This screen shows a fuel order, not a generic provider request.
            title: 'تفاصيل طلب الوقود',
            showBackButton: true,
            backgroundColor: AppColors.carWashTeal,
            onBackTapped: () => context.safePopOrGo(Routes.provider_order),
          ),
          body: BlocListener<FuelProviderOrderCubit, FuelProviderOrderState>(
            listener: (context, state) {
              if (state is FuelProviderOrderAccepted) {
                AppSnackBar.success(context, "تم قبول الطلب");
                context.safePopOrGo(Routes.provider_order);
              }

              if (state is FuelProviderOrderStarted) {
                AppSnackBar.success(context, "تم بدء تنفيذ الطلب");
                // Stay on this page and reload so the correct next action
                // (إكمال الطلب) shows for the new in_progress status.
                context.read<FuelProviderOrderCubit>().getOrder(id);
              }

              if (state is FuelProviderOrderCompleted) {
                AppSnackBar.success(context, "تم إكمال الطلب");
                context.safePopOrGo(Routes.provider_order);
              }

              if (state is FuelProviderOrderError) {
                AppSnackBar.error(context, state.message);
              }
            },
            child: ImageBackground(
              child:
                  BlocBuilder<FuelProviderOrderCubit, FuelProviderOrderState>(
                    builder: (context, state) {
                      if (state is FuelProviderOrderLoading) {
                        return const Center(child: AppLoadingWidget());
                      }

                      if (state is FuelProviderOrderDetailsLoaded) {
                        final order = state.order;

                        return ProviderOrderDetailsBody(
                          order: order,
                          onAcceptOrder: () async {
                            final result = await showProviderAcceptOrderDialog(
                              context,
                            );

                            if (result != null &&
                                order.id != null &&
                                context.mounted) {
                              final minutes = int.tryParse(result.minutes);
                              final notes = result.notes.trim();
                              context
                                  .read<FuelProviderOrderCubit>()
                                  .acceptOrder(
                                    order.id!,
                                    estimatedArrivalMinutes:
                                        minutes != null && minutes > 0
                                        ? minutes
                                        : null,
                                    notes: notes.isEmpty ? null : notes,
                                  );
                            }
                          },
                          onStartOrder: order.id != null
                              ? () => context
                                    .read<FuelProviderOrderCubit>()
                                    .startOrder(order.id!)
                              : null,
                          onCompleteOrder: order.id != null
                              ? () => context
                                    .read<FuelProviderOrderCubit>()
                                    .completeOrder(order.id!)
                              : null,
                        );
                      }

                      return const SizedBox();
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
