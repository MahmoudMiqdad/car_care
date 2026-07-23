// ignore_for_file: deprecated_member_use

import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_state.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileInfoCard.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
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
          final msg = state.message.isEmpty ||
                  state.message.startsWith('Instance of')
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
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _AvailabilityToggle(isAvailable: isAvailable),
                    SizedBox(height: 20.h),

                    ProfileInfoCard(
                      title: 'التخصص',
                      value: profile.data?.specialization ?? '-',
                      icon: Icons.work_outline,
                    ),
                    SizedBox(height: 16.h),

                    ProfileInfoCard(
                      title: 'سنوات الخبرة',
                      value: profile.data?.experienceYears?.toString() ?? '-',
                      icon: Icons.timeline,
                    ),
                    SizedBox(height: 16.h),

                    ProfileInfoCard(
                      title: strings.phoneNumber,
                      value: profile.data?.phone ?? '-',
                      icon: Icons.phone_in_talk_outlined,
                    ),
                    SizedBox(height: 16.h),

                    ProfileInfoCard(
                      title: 'المدينة',
                      value: profile.data?.city ?? '-',
                      icon: Icons.location_on_outlined,
                    ),
                    SizedBox(height: 16.h),

                    ProfileInfoCard(
                      title: 'الأجر بالساعة',
                      value: profile.data?.hourlyRate?.toString() ?? '-',
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: 24.h),

                    if (certifications.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الشهادات:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      GridView.builder(
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
                                  backgroundColor: Colors.transparent,
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    minScale: 1,
                                    maxScale: 5,
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) =>
                                          Container(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    Container(color: Colors.grey[300]),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],

                    AppButton(
                      text: 'تعديل البيانات',
                      backgroundColor: AppColors.orange,
                      onPressed: () => context.push(
                        Routes.updateTechnicianProfile,
                        extra: profile.data,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

// ─── ويدجت زر الـ Availability ────────────────────────────────────────────────

class _AvailabilityToggle extends StatelessWidget {
  final bool isAvailable;

  const _AvailabilityToggle({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TechnicianAvailabilityCubit,
        TechnicianAvailabilityState>(
      listener: (context, state) {
        if (state is TechnicianAvailabilityError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        // بعد نجاح التغيير، حدّث البروفايل عشان يتغير الـ Switch
        if (state is TechnicianAvailabilitySuccess) {
          context.read<TechnicianProfileCubit>().getTechnicianProfile();
        }
      },
      builder: (context, availState) {
        final isLoading = availState is TechnicianAvailabilityLoading;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isAvailable ? Colors.green.shade300 : Colors.red.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ─── أيقونة الحالة ──────────────────────────────────────
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  color: isAvailable
                      ? Colors.green.shade600
                      : Colors.red.shade400,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة التوفر',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isAvailable ? 'متاح للعمل' : 'غير متاح',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: isAvailable
                            ? Colors.green.shade700
                            : Colors.red.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              isLoading
                  ? SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.orange,
                      ),
                    )
                  : Switch(
                      value: isAvailable,
                      activeThumbColor: Colors.green.shade600,
                      inactiveThumbColor: Colors.red.shade400,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (val) {
                        context
                            .read<TechnicianAvailabilityCubit>()
                            .changeAvailability(val ? '1' : '0');
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}