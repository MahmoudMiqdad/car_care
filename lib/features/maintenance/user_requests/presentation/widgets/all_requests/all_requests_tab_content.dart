import 'package:car_care/features/technician/technician_jobs/presentation/widgets/technician_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllRequestsTabContent extends StatelessWidget {
  const AllRequestsTabContent({super.key, required this.jobs});

  final List<TechnicianJobUiModel> jobs;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      children: [
               SizedBox(height: 24.h),

        ...jobs.map(
          (job) => Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: TechnicianJobCard(job: job),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
