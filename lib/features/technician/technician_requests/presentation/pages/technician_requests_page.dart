import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_requests/presentation/widgets/accepted_request_card.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:flutter/material.dart';
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
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            children: [
              RefreshHint(
                hintText: 'تحديث سجل الطلبات ...',
                onTap: () {},
              ),
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
    );
  }
}
