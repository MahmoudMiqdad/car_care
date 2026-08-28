import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/washers/washers_availability/presentation/cubit/availability_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_state.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/pages/create_profile_washer_page.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_body.dart';

import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileWasherPage extends StatelessWidget {
  const ProfileWasherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileWasherCubit>()..load()),
        BlocProvider(create: (_) => getIt<AvailabilityCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: CustomAppBar(
          title: l10n.profileWasherPageTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.home);
            }
          },
        ),
        body: ImageBackground(
          child: BlocConsumer<ProfileWasherCubit, ProfileWasherState>(
            listener: (context, state) {
              if (state is ProfileWasherError) {
                AppSnackBar.error(context, localizeErrorMessage(context, state.message));
              }
            },
            builder: (context, state) {
              if (state is ProfileWasherLoading ||
                  state is ProfileWasherInitial) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is ProfileWasherEmpty) {
                return const CreateProfileWasherPage();
              }

              if (state is ProfileWasherLoaded) {
                final profile = state.profile;
                final effectiveStatus =
                    (profile.status != null && profile.status!.isNotEmpty)
                    ? profile.status
                    : (profile.isVerified ? null : 'pending');
                final gate = buildProviderStatusGate(
                  effectiveStatus,
                  profile.rejectionReason,
                );
                if (gate != null) return gate;
                return ProfileWasherBody(profile: profile);
              }

              if (state is ProfileWasherError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: AppColors.red),
                      const SizedBox(height: 16),
                      Text(
                        localizeErrorMessage(context, state.message),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<ProfileWasherCubit>().load(),
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
