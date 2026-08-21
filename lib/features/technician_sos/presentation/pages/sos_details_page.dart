// ignore_for_file: constant_identifier_names
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/utils/media_url.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_details/technician_sos_details_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SosTechnicianDetailsPage extends StatelessWidget {
  final int id;

  const SosTechnicianDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: l10n.sosDetailsTitle,
        showBackButton: true,
        backgroundColor: AppColors.carWashTeal,
        onBackTapped: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(Routes.technician_sos_requests);
          }
        },
      ),
      body: ImageBackground(
        child: BlocProvider(
          create: (_) => getIt<TechnicianSosCubit>()..getRequest(id),
          child: BlocBuilder<TechnicianSosCubit, TechnicianSosState>(
            builder: (context, state) {
              if (state is TechnicianLoading) {
                return const Center(child: AppLoadingWidget());
              }

              final item = state is TechnicianRequestLoaded
                  ? state.request
                  : (state is TechnicianActionError ? state.request : null);

              if (item != null) {
                return SosTechnicianDetailsBody(
                  sos: item,
                  vehicleTitle: buildVehicleLabel(
                    brand: item.vehicleBrand,
                    model: item.vehicleModel,
                    year: item.vehicleYear,
                  ),
                  vehicleImageUrl: resolveMediaUrl(
                    item.vehicleImage ?? item.vehicleImagePath,
                  ),
                  plateNumber: item.plateNumber?.toString() ?? '',
                  ownerName: item.ownerName ?? '',
                  description: item.description ?? '',
                );
              }

              if (state is TechnicianError || state is TechnicianActionError) {
                final message = state is TechnicianError
                    ? state.message
                    : (state as TechnicianActionError).message;
                return ErrorStateWidget(
                  message: message.isEmpty || message.startsWith('Instance of')
                      ? l10n.unexpectedErrorTryAgain
                      : message,
                  onRetry: () =>
                      context.read<TechnicianSosCubit>().getRequest(id),
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
