import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AllRequestsTabContent extends StatelessWidget {
  const AllRequestsTabContent({
    super.key,
    required this.jobs,
    required this.onReturnFromDetails,
  });

  final List<DataEntity>jobs;
  final VoidCallback onReturnFromDetails;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
         final item = jobs[index];
        return UserCard(
  job: item,
  onTap: () async {
    await context.push(
      Routes.maintenance_request_details,
      extra: item.id,
    );
    onReturnFromDetails();
  },
);
      },
    );
  }
}