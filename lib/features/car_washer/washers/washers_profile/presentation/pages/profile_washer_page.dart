import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_state.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/profile_page/profile_washer_body.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void profileWasherBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(Routes.home);
  }
}

class ProfileWasherPage extends StatelessWidget {
  const ProfileWasherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileWasherCubit>()..load(),
      child: const _ProfileWasherRouter(),
    );
  }
}

class _ProfileWasherRouter extends StatelessWidget {
  const _ProfileWasherRouter();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileWasherCubit, ProfileWasherState>(
      listenWhen: (previous, current) =>
          current is ProfileWasherEmpty && previous is! ProfileWasherEmpty,
      listener: (context, state) {
        if (state is ProfileWasherEmpty) {
          context.go(Routes.create_profile_washer);
        }
        if (state is ProfileWasherError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is ProfileWasherLoading || state is ProfileWasherInitial) {
          return const _ProfileWasherLoadingPage();
        }

        if (state is ProfileWasherEmpty || state is ProfileWasherSaving) {
          return const SizedBox.shrink();
        }

        if (state is ProfileWasherLoaded) {
          final gate = buildProviderStatusGate(
            state.profile.status,
            state.profile.rejectionReason,
          );
          if (gate != null) return gate;
          return ProfileWasherViewPage(profile: state.profile);
        }

        if (state is ProfileWasherError) {
          return _ProfileWasherErrorPage(message: state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ProfileWasherLoadingPage extends StatelessWidget {
  const _ProfileWasherLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        body: const ImageBackground(
          child: Center(child: AppLoadingWidget()),
        ),
      ),
    );
  }
}

class _ProfileWasherErrorPage extends StatelessWidget {
  const _ProfileWasherErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: context.l10n.profileWasherPageTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => profileWasherBack(context),
        ),
        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
        body: ImageBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.read<ProfileWasherCubit>().load(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة محاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileWasherViewPage extends StatelessWidget {
  const ProfileWasherViewPage({super.key, required this.profile});

  final WasherProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.profileWasherPageTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => profileWasherBack(context),
        ),
        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
        body: ImageBackground(
          child: ProfileWasherBody(profile: profile),
        ),
      ),
    );
  }
}
