import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart'; // تأكد من استيراد الـ service locator
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/cancel_reason_dialog.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_state.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_accept_order_dialog.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/widgets/provider_order_details/provider_order_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Backend contract for POST /fuel_provider/orders/{id}/cancel:
/// cancellation_reason is required, min:5. Top-level so it's directly
/// unit-testable without pumping the dialog widget.
String? validateFuelProviderCancellationReason(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return 'يرجى إدخال سبب الإلغاء';
  if (trimmed.length < 5) {
    return 'سبب الإلغاء يجب ألا يقل عن 5 أحرف';
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
  /// Guards the accept flow (dialog + cubit call) against a double tap on
  /// the "قبول الطلب" button before the loading state has a chance to hide
  /// it — reset regardless of outcome (confirmed, cancelled, or dismissed).
  bool _acceptInFlight = false;

  /// True once a mutation actually succeeded during this visit — reported
  /// back to whichever tab opened this page when the user leaves it, so
  /// that tab can refresh itself exactly once. Accept/complete/cancel leave
  /// this page automatically on success and already carry `result: true`
  /// directly; this flag exists for "بدء التنفيذ", which intentionally
  /// keeps the user on this page afterward.
  bool _orderChanged = false;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.safePopOrGo(Routes.provider_order, result: _orderChanged);
      },
      child: BlocProvider(
        create: (_) => getIt<FuelProviderOrderCubit>()..getOrder(widget.id),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.lightScaffold,
            appBar: CustomAppBar(
              // This screen shows a fuel order, not a generic provider request.
              title: 'تفاصيل طلب الوقود',
              showBackButton: true,
              backgroundColor: AppColors.carWashTeal,
              onBackTapped: () => context.safePopOrGo(
                Routes.provider_order,
                result: _orderChanged,
              ),
            ),
            body: BlocListener<FuelProviderOrderCubit, FuelProviderOrderState>(
              listener: (context, state) {
                if (state is FuelProviderOrderAccepted) {
                  AppSnackBar.success(context, "تم قبول الطلب");
                  context.safePopOrGo(Routes.provider_order, result: true);
                }

                if (state is FuelProviderOrderStarted) {
                  AppSnackBar.success(context, "تم بدء تنفيذ الطلب");
                  setState(() => _orderChanged = true);
                  // Stay on this page and reload so the correct next action
                  // (إكمال الطلب) shows for the new in_progress status.
                  context.read<FuelProviderOrderCubit>().getOrder(widget.id);
                }

                if (state is FuelProviderOrderCompleted) {
                  AppSnackBar.success(context, "تم إكمال الطلب");
                  context.safePopOrGo(Routes.provider_order, result: true);
                }

                if (state is FuelProviderOrderCancelled) {
                  AppSnackBar.success(context, "تم إلغاء الطلب");
                  // The order goes back to pending — leave this page instead
                  // of showing now-stale accepted/in_progress actions.
                  context.safePopOrGo(Routes.provider_order, result: true);
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
                                              notes: notes.isEmpty
                                                  ? null
                                                  : notes,
                                            );
                                      }
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
                                      title: 'إلغاء طلب الوقود',
                                      question: 'يرجى ذكر سبب إلغاء الطلب',
                                    );
                                    if (reason == null || !context.mounted) {
                                      return;
                                    }
                                    final validationError =
                                        validateFuelProviderCancellationReason(
                                          reason,
                                        );
                                    if (validationError != null) {
                                      AppSnackBar.error(
                                        context,
                                        validationError,
                                      );
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
      ),
    );
  }
}
