import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileInfoCard.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_state.dart';
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

    return BlocBuilder<TechnicianProfileCubit, TechnicianProfileState>(
      builder: (context, state) {
        // Loading
        if (state is TechnicianProfileLoading) {
          return const Center(child: AppLoadingWidget());
        }

        // Error
        if (state is TechnicianProfileError) {
          return Center(child: Text(state.message));
        }

        // Success
        if (state is TechnicianProfileLoaded) {
          final profile = state.profile;
          final certifications = profile.data?.certifications ?? [];

          return Directionality(
            textDirection: TextDirection.rtl,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<TechnicianProfileCubit>().getTechnicianProfile();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  
                  

                   
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      onPressed: () =>
                          context.push(Routes.updateTechnicianProfile),
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
