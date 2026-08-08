// ignore_for_file: constant_identifier_names
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_state.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/cancel_sos_dialog.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_body.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_details/sos_details_location_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class SosDetailsPage extends StatelessWidget {
  final int id;

  const SosDetailsPage({super.key, required this.id});

  Future<void> _showCancelDialog(
    BuildContext context,
    SosCubit cubit,
    int sosId,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const CancelSosDialog(),
    );

    if (reason != null && context.mounted) {
      cubit.cancelSos(sosId, reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.sosDetailsTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.allUserSosRequests);
            }
          },
        ),
        body: ImageBackground(
          child: BlocProvider(
            create: (_) => getIt<SosCubit>()..getSosRequest(id),

            child: BlocListener<SosCubit, SosState>(
              listener: (context, state) {
       
                if (state is SosCansel) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(state.message),
                    ),
                  );

                
                  context.read<SosCubit>().getSosRequest(id);
                }

        
                if (state is SosError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.message),
                    ),
                  );

                  
                  if (state.message.toLowerCase().contains("not found")) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(Routes.allUserSosRequests);
                    }
                  }
                }
              },

              child: BlocBuilder<SosCubit, SosState>(
                builder: (context, state) {
                  if (state is SosLoading) {
                    return const Center(child: AppLoadingWidget());
                  }

                  if (state is SosError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is SosRequestLoaded) {
                    final item = state.sos;
                    final cubit = context.read<SosCubit>();

                    // Tracking is only meaningful while the technician is
                    // actively on the way; hidden for open / accepted /
                    // completed / cancelled and any unknown status.
                    final canTrack =
                        item.id != null && item.status == 'in_progress';

                    return SosDetailsBody(
                      sos: item,
                      vehicleTitle:
                          "${item.vehicleBrand ?? ''} ${item.vehicleModel ?? ''}",
                      plateNumber: item.plateNumber?.toString() ?? '',
                      technicianName: item.technicianName ?? '',
                      description: item.description ?? '',
                      onTrackTapped: canTrack
                          ? () => showSosTrackingSheet(context, item.id!)
                          : null,
                      onCancelTapped: () =>
                          _showCancelDialog(context, cubit, item.id!),
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