// ignore_for_file: deprecated_member_use

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_availability_card.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_info_row.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianProfileViewBody extends StatelessWidget {
  const TechnicianProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
      listenWhen: (_, current) => current is TechnicianProfileError,
      listener: (context, state) {
        if (state is TechnicianProfileError) {
          final msg =
              state.message.isEmpty || state.message.startsWith('Instance of')
              ? strings.profileLoadError
              : localizeErrorMessage(context, state.message);
          AppSnackBar.error(context, msg);
        }
      },
      builder: (context, state) {
        if (state is TechnicianProfileLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is TechnicianProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.red),
                const SizedBox(height: 12),
                Text(strings.profileLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context
                      .read<TechnicianProfileCubit>()
                      .getTechnicianProfile(),
                  icon: const Icon(Icons.refresh),
                  label: Text(strings.retry),
                ),
              ],
            ),
          );
        }

        if (state is TechnicianProfileLoaded) {
          final profile = state.profile;
          final certifications = profile.data?.certifications ?? [];
          final isAvailable = profile.data?.isAvailable ?? false;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TechnicianProfileCubit>().getTechnicianProfile();
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TechnicianAvailabilityCard(isAvailable: isAvailable),
                        SizedBox(height: 14.h),

                        TechnicianProfileSection(
                          title: strings.professionalInfo,
                          icon: Icons.engineering_outlined,
                          color: AppColors.accent,
                          child: Column(
                            children: [
                              TechnicianInfoRow(
                                icon: Icons.work_outline,
                                label: strings.specialization,
                                value: profile.data?.specialization ?? '-',
                              ),
                              SizedBox(height: 14.h),
                              TechnicianInfoRow(
                                icon: Icons.timeline,
                                label: strings.experienceYears,
                                value:
                                    profile.data?.experienceYears?.toString() ??
                                    '-',
                              ),
                              SizedBox(height: 14.h),
                              TechnicianInfoRow(
                                icon: Icons.attach_money,
                                label: strings.hourlyRate,
                                value:
                                    profile.data?.hourlyRate?.toString() ?? '-',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),

                        TechnicianProfileSection(
                          title: strings.contactInfo,
                          icon: Icons.person_outline,
                          color: AppColors.primary,
                          child: Column(
                            children: [
                              TechnicianInfoRow(
                                icon: Icons.phone_in_talk_outlined,
                                label: strings.phoneNumber,
                                value: profile.data?.phone ?? '-',
                              ),
                              SizedBox(height: 14.h),
                              TechnicianInfoRow(
                                icon: Icons.location_on_outlined,
                                label: strings.city,
                                value: profile.data?.city ?? '-',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),

                        TechnicianProfileSection(
                          title: strings.certifications,
                          icon: Icons.workspace_premium_outlined,
                          color: AppColors.primary,
                          child: certifications.isEmpty
                              ? const _EmptyCertificates()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: certifications.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8.w,
                                        mainAxisSpacing: 8.h,
                                      ),
                                  itemBuilder: (context, index) {
                                    final url = certifications[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            backgroundColor:
                                                AppColors.transparent,
                                            child: InteractiveViewer(
                                              panEnabled: true,
                                              minScale: 1,
                                              maxScale: 5,
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, _, _) =>
                                                    Container(
                                                      color: context
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Container(
                                            color: context
                                                .colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                    child: AppButton(
                      text: strings.editProfile,
                      onPressed: () async {
                        final updated = await context.push<bool>(
                          Routes.updateTechnicianProfile,
                          extra: profile.data,
                        );
                        if (updated == true && context.mounted) {
                          context
                              .read<TechnicianProfileCubit>()
                              .getTechnicianProfile();
                          AppSnackBar.success(
                            context,
                            strings.profileUpdatedSuccessfully,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _EmptyCertificates extends StatelessWidget {
  const _EmptyCertificates();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 18.r,
            color: context.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              strings.noCertificatesUploaded,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
