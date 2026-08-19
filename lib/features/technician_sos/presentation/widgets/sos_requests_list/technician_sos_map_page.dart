import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/share_technician_location_cubit/share_technician_location_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_state.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/technician_sos_map_widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianSosMapPage extends StatelessWidget {
  final int sosId;
  final double? clientLat;
  final double? clientLng;

  const TechnicianSosMapPage({
    super.key,
    required this.sosId,
    this.clientLat,
    this.clientLng,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ShareTechnicianLocationSosCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<TechnicianSosCubit>()..getRequest(sosId),
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          appBar: AppBar(
            backgroundColor: AppColors.carWashTeal,
            foregroundColor: AppColors.white,
            title: Text(
              l10n.trackOrderWithIdLabel(sosId.toString()),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(l10n.confirmExitTitle),
                    content: Text(l10n.stopSharingLocationWarning),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.no),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.safePopOrGo(Routes.technician_sos_requests);
                        },
                        child: Text(
                          l10n.exitActionLabel,
                          style: TextStyle(color: AppColors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: BlocListener<TechnicianSosCubit, TechnicianSosState>(
            listener: (context, state) {
              if (state is TechnicianRequestLoaded &&
                  state.request.status == 'completed') {
            AppSnackBar.error(context, l10n.jobCompletedSuccessMessage);
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) {
                    context.safePopOrGo(Routes.technician_sos_requests);
                  }
                });
              }
            },
            child: TechnicianMapWidget(
              sosId: sosId,
              userLat: clientLat,
              userLng: clientLng,
            ),
          ),
        ),
      ),
    );
  }
}
