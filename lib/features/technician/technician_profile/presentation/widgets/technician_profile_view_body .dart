// ignore_for_file: deprecated_member_use

import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
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
              ? 'حدث خطأ أثناء تحميل الملف'
              : state.message;
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
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'حدث خطأ أثناء تحميل الملف',
                  textAlign: TextAlign.center,
                ),
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
          );
        }

        if (state is TechnicianProfileLoaded) {
          final profile = state.profile;
          final certifications = profile.data?.certifications ?? [];
          final isAvailable = profile.data?.isAvailable ?? false;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: RefreshIndicator(
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
                            title: 'البيانات المهنية',
                            icon: Icons.engineering_outlined,
                            color: AppColors.orange,
                            child: Column(
                              children: [
                                TechnicianInfoRow(
                                  icon: Icons.work_outline,
                                  label: 'التخصص',
                                  value: profile.data?.specialization ?? '-',
                                ),
                                SizedBox(height: 14.h),
                                TechnicianInfoRow(
                                  icon: Icons.timeline,
                                  label: 'سنوات الخبرة',
                                  value:
                                      profile.data?.experienceYears
                                          ?.toString() ??
                                      '-',
                                ),
                                SizedBox(height: 14.h),
                                TechnicianInfoRow(
                                  icon: Icons.attach_money,
                                  label: 'الأجر بالساعة',
                                  value:
                                      profile.data?.hourlyRate?.toString() ??
                                      '-',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),

                          TechnicianProfileSection(
                            title: 'بيانات التواصل',
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
                                  label: 'المدينة',
                                  value: profile.data?.city ?? '-',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),

                          TechnicianProfileSection(
                            title: 'الشهادات',
                            icon: Icons.workspace_premium_outlined,
                            color: AppColors.primary,
                            child: certifications.isEmpty
                                ? _EmptyCertificates()
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                  Colors.transparent,
                                              child: InteractiveViewer(
                                                panEnabled: true,
                                                minScale: 1,
                                                maxScale: 5,
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, _, _) =>
                                                      Container(
                                                        color: Colors.grey[300],
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
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                                  color: Colors.grey[300],
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

                  // ─── زر التعديل (فوق الشريط الآمن دائمًا) ────────────
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                      child: AppButton(
                        text: 'تعديل الملف',
                        backgroundColor: AppColors.orange,
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
                              'تم تحديث الملف الشخصي بنجاح ✓',
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _EmptyCertificates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 18.r,
            color: Colors.grey.shade400,
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              'لا توجد شهادات مرفوعة بعد',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
