import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widget/accepted_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianRequestsPage extends StatelessWidget {
  const TechnicianRequestsPage({super.key});

  static const List<AcceptedRequestUiModel> _sampleRequests = [
    AcceptedRequestUiModel(
      activePhase: AcceptedRequestWorkPhase.inProgress,
      description: 'عطل في الكولاس',
      clientName: 'محمود المقداد',
      vehicle: 'مرسيدس بينز',
      appointmentDate: '2026/8/8',
      appointmentNotes: ' صباحاً',
    ),
    AcceptedRequestUiModel(
      activePhase: AcceptedRequestWorkPhase.waiting,
      description: 'عطل في البطارية',
      clientName: 'علي أحمد',
      vehicle: 'تويوتا كورولا',
      appointmentDate: '2026/8/9',
      appointmentNotes: 'بعد الظهر',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Accepted requests',
        showBackButton: true,
      ),
      bottomNavigationBar: HomeBottomNavBar(
        activeIndex: 0,
        onItemSelected: (index) {
          if (index == 0) context.go(Routes.home);
        },
      ),
      body: ImageBackground(
        child: SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                context.read<TechnicianJobsCubit>().fetchMyJobs();
              },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              children: [
             
                ..._sampleRequests.map(
                  (req) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: AcceptedRequestCard(request: req),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
