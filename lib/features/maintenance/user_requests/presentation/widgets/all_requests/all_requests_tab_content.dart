import 'package:car_care/features/maintenance/user_requests/data/models/maintenance_request_model.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllRequestsTabContent extends StatelessWidget {
  const AllRequestsTabContent({super.key, required this.jobs});

  final List<DataEntity>jobs;
  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
         final item = jobs[index];
        return UserCard(job: item );
      },
    );
  }
}