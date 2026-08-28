import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/cancel_reason_dialog.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_accept_order_dialog.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_order_details_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String? validateFuelProviderCancellationReason(
  BuildContext context,
  String? value,
) {
  final l10n = context.l10n;
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return l10n.pleaseEnterCancellationReason;
  if (trimmed.length < 5) {
    return l10n.cancellationReasonMinLengthError.toString();
  }
  return null;
}

class ProviderOrderDetailsPage extends StatefulWidget {
  const ProviderOrderDetailsPage({super.key, required this.id});

  final int id;

  @override
  State<ProviderOrderDetailsPage> createState() =>
      _ProviderOrderDetailsPageState();
}

class _ProviderOrderDetailsPageState extends State<ProviderOrderDetailsPage> {
  bool _acceptInFlight = false;
  bool _orderChanged = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.safePopOrGo(Routes.provider_order, result: _orderChanged);
      },
      child: BlocProvider(
        create: (_) => getIt<FuelProviderOrderCubit>()..getOrder(widget.id),
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          appBar: CustomAppBar(
            title: l10n.fuelOrderDetailsTitle,
            showBackButton: true,
            backgroundColor: AppColors.carWashTeal,
            onBackTapped: () => context.safePopOrGo(
              Routes.provider_order,
              result: _orderChanged,
            ),
          ),
          body: ImageBackground(
            child: BlocListener<FuelProviderOrderCubit, FuelProviderOrderState>(
              listener: (context, state) {
                if (state is FuelProviderOrderAccepted) {
                  AppSnackBar.success(context, l10n.orderAcceptedSuccess);
                  context.safePopOrGo(Routes.provider_order, result: true);
                }
            
                if (state is FuelProviderOrderStarted) {
                  AppSnackBar.success(context, l10n.orderStartedSuccess);
                  setState(() => _orderChanged = true);
                  context.read<FuelProviderOrderCubit>().getOrder(widget.id);
                }
            
                if (state is FuelProviderOrderCompleted) {
                  AppSnackBar.success(context, l10n.orderCompletedSuccess);
                  context.safePopOrGo(Routes.provider_order, result: true);
                }
            
                if (state is FuelProviderOrderCancelled) {
                  AppSnackBar.success(context, l10n.orderCancelledSuccess);
                  context.safePopOrGo(Routes.provider_order, result: true);
                }
            
                if (state is FuelProviderOrderError) {
                  AppSnackBar.error(context, localizeErrorMessage(context, state.message));
                }
            
                if (state is FuelProviderOrderActionError) {
                  AppSnackBar.error(context, localizeErrorMessage(context, state.message));
                }
              },
              child: BlocBuilder<FuelProviderOrderCubit, FuelProviderOrderState>(
                builder: (context, state) {
                  if (state is FuelProviderOrderLoading) {
                    return const Center(child: AppLoadingWidget());
                  }
              
                  final order = state is FuelProviderOrderDetailsLoaded
                      ? state.order
                      : (state is FuelProviderOrderActionError
                            ? state.order
                            : null);
              
                  if (order != null) {
                    return ProviderOrderDetailsBody(
                      order: order,
                      onAcceptOrder: _acceptInFlight
                          ? null
                          : () async {
                              if (_acceptInFlight) return;
                              setState(() => _acceptInFlight = true);
                              try {
                                final result =
                                    await showProviderAcceptOrderDialog(
                                      context,
                                    );
              
                                if (result != null &&
                                    order.id != null &&
                                    context.mounted) {
                                  final minutes = int.tryParse(
                                    result.minutes,
                                  );
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
                              } catch (_) {
                              } finally {
                                if (context.mounted) {
                                  setState(() => _acceptInFlight = false);
                                }
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
                      onCancelOrder: order.id != null
                          ? () async {
                              final reason = await showCancelReasonDialog(
                                context,
                                title: l10n.cancelFuelOrderTitle,
                                question:
                                    l10n.pleaseEnterCancellationReason,
                              );
                              if (reason == null || !context.mounted) {
                                return;
                              }
                              final validationError =
                                  validateFuelProviderCancellationReason(
                                    context,
                                    reason,
                                  );
                              if (validationError != null) {
                                AppSnackBar.error(context, validationError);
                                return;
                              }
                              context
                                  .read<FuelProviderOrderCubit>()
                                  .cancelOrder(order.id!, reason.trim());
                            }
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
