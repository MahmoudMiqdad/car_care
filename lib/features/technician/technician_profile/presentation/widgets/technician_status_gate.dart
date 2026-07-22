import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Gates any technician screen behind the technician profile status.
/// Having the technician role does NOT mean approved — the profile
/// status decides access:
/// - no profile  -> redirect to create technician profile
/// - pending     -> "حسابك قيد المراجعة"
/// - rejected    -> rejection reason
/// - suspended   -> suspended page
/// - approved    -> [child]
class TechnicianStatusGate extends StatelessWidget {
  const TechnicianStatusGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<TechnicianProfileCubit>()
                          .getTechnicianProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
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
