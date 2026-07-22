// provider_profile_page.dart
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/fuel_provider/provider_profile/domain/entities/provider_profile_entity.dart';
import 'package:car_care/features/fuel_provider/provider_profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:car_care/features/fuel_provider/provider_profile/presentation/cubit/provider_profile_state.dart';
import 'package:car_care/features/fuel_provider/provider_profile/presentation/widgets/provider_profile/provider_profile_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  bool? _localAvailability;

  @override
  void initState() {
    super.initState();
    context.read<FuelProviderProfileCubit>().myProfile();
  }

  Widget _buildBody(
    BuildContext context,
    FuelProviderProfileEntity profile,
  ) {
    final isAvailable = _localAvailability ?? profile.isAvailable ?? false;

    return ImageBackground(
      child: ProviderProfileBody(
        profile: profile,
        isAvailable: isAvailable,
        onAvailabilityChanged: (value) {
          setState(() => _localAvailability = value);
          context.read<FuelProviderProfileCubit>().updateAvailability(value);
        },
        onEditProfile: () async {
          await context.push(
            Routes.provider_edit_profile,
            extra: profile,
          );
          if (context.mounted) {
            context.read<FuelProviderProfileCubit>().myProfile();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.providerProfilePageTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.pop(),
        ),
        body: BlocConsumer<FuelProviderProfileCubit, FuelProviderProfileState>(
          listener: (context, state) {
            if (state is FuelProviderProfileError) {
              final msg = state.message.toLowerCase();
              final isNotFound = msg.contains('404') ||
                  msg.contains('not found') ||
                  msg.contains('غير موجود') ||
                  msg.contains('لم');
              if (isNotFound) {
                context.go(Routes.provider_create_profile);
              } else {
                AppSnackBar.error(context, state.message);
              }
            }
          },
          builder: (context, state) {
            if (state is FuelProviderProfileLoading) {
              return const Center(child: AppLoadingWidget());
            }

            if (state is FuelProviderProfileLoaded) {
              final gate = buildProviderStatusGate(
                state.profile.status,
                state.profile.rejectionReason,
              );
              if (gate != null) return gate;
              return _buildBody(context, state.profile);
            }

            // بعد updateAvailability أو updatePrices نستخدم currentProfile
            if (state is FuelProviderAvailabilityUpdated ||
                state is FuelProviderPricesUpdated) {
              final profile =
                  context.read<FuelProviderProfileCubit>().currentProfile;
              if (profile != null) {
                return _buildBody(context, profile);
              }
            }

            if (state is FuelProviderProfileError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () =>
                          context.read<FuelProviderProfileCubit>().myProfile(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}