import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TechnicianStatusGate extends StatelessWidget {
  const TechnicianStatusGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<TechnicianProfileCubit>()..getTechnicianProfile(),
      child: BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
        listener: (context, state) {
          if (state is TechnicianProfileError) {
            final msg = state.message.toLowerCase();
            final isNotFound = msg.contains('404') ||
                msg.contains('not found') ||
                msg.contains('غير موجود') ||
                msg.contains('لا يوجد') ||
                msg.contains('لم');
            if (isNotFound) {
              context.go(Routes.inserttechnicianprofile);
            }
          }
        },
        builder: (context, state) {
          if (state is TechnicianProfileLoading ||
              state is TechnicianProfileInitial) {
            return const Scaffold(
              body: Center(child: AppLoadingWidget()),
            );
          }

          if (state is TechnicianProfileLoaded) {
            final gate = buildProviderStatusGate(
              state.profile.data?.status,
              state.profile.data?.rejectionReason,
            );
            if (gate != null) return gate;
            return child;
          }

          if (state is TechnicianProfileError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<TechnicianProfileCubit>()
                          .getTechnicianProfile(),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }
}
