import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/technician_job_card.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianJobsPage extends StatelessWidget {
  const TechnicianJobsPage({super.key});

  static const List<TechnicianJobUiModel> _sampleJobs = [
    TechnicianJobUiModel(
      status: TechnicianJobCardStatus.waiting,
      description: 'عطل في الكولاس',
      customerName: 'محمود المقداد',
      vehicle: 'مرسيدس بينز',
      appointmentDate: '2026/8/8',
      priceOffer: '\$200',
    ),
    TechnicianJobUiModel(
      status: TechnicianJobCardStatus.rejected,
      description: 'عطل في البطارية',
      customerName: 'علي أحمد',
      vehicle: 'تويوتا كورولا',
      appointmentDate: '2026/8/8',
      priceOffer: '\$150',
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
                onTap: () {
                  // Add refresh logic here
                },
              ),
              ..._sampleJobs.map(
                (job) => Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: TechnicianJobCard(job: job),
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