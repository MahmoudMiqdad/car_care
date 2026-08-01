import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/technician/technician_jobs/domain/entities/technician_jobs_entity.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_state.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/technician_job_card.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianJobsPage extends StatelessWidget {
  const TechnicianJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TechnicianJobsCubit>()..fetchMyJobs(),
      child: const _TechnicianJobsBody(),
    );
  }
}

class _TechnicianJobsBody extends StatelessWidget {
  const _TechnicianJobsBody();

  /// Maps the backend job status to the card's colour bucket + Arabic label.
  static (TechnicianJobCardStatus, String) _statusOf(String status) {
    return switch (status.toLowerCase()) {
      'rejected' || 'cancelled' || 'canceled' => (
          TechnicianJobCardStatus.rejected,
          'ملغي',
        ),
      'completed' => (TechnicianJobCardStatus.waiting, 'مكتمل'),
      'in_progress' || 'in-progress' => (
          TechnicianJobCardStatus.waiting,
          'قيد التنفيذ',
        ),
      'accepted' => (TechnicianJobCardStatus.waiting, 'مقبول'),
      _ => (TechnicianJobCardStatus.waiting, 'إنتظار'),
    };
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}/${date.month}/${date.day}';
  }

  TechnicianJobUiModel _toUiModel(JobEntity job) {
    final (cardStatus, label) = _statusOf(job.status);
    return TechnicianJobUiModel(
      status: cardStatus,
      statusLabel: label,
      description: job.description.isEmpty ? '-' : job.description,
      customerName: job.customerName.isEmpty ? '-' : job.customerName,
      vehicle: job.vehicleLabel,
      appointmentDate: _formatDate(job.scheduledDate),
      // Hidden entirely when the backend has no quotation price.
      priceOffer:
          job.quotationPrice == null ? null : '\$${job.quotationPrice}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TechnicianJobsCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'أعمالي',
          showBackButton: true,
          fallbackRoute: Routes.more,
        ),
        bottomNavigationBar: HomeBottomNavBar(
          activeIndex: -1,
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
        body: ImageBackground(
          child: SafeArea(
            child: BlocBuilder<TechnicianJobsCubit, TechnicianJobsState>(
              builder: (context, state) {
                if (state is TechnicianJobsLoading) {
                  return const Center(child: AppLoadingWidget());
                }

                if (state is TechnicianJobsError) {
                  return ErrorStateWidget(
                    message: state.message.isEmpty ||
                            state.message.startsWith('Instance of')
                        ? 'حدث خطأ أثناء تحميل الأعمال'
                        : state.message,
                    onRetry: cubit.fetchMyJobs,
                  );
                }

                if (state is TechnicianJobsLoaded) {
                  final jobs = state.jobs.jobs;

                  return RefreshIndicator(
                    onRefresh: cubit.fetchMyJobs,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      children: [
                        RefreshHint(
                          hintText: 'تحديث سجل الطلبات ...',
                          onTap: cubit.fetchMyJobs,
                        ),
                        if (jobs.isEmpty) ...[
                          SizedBox(height: 40.h),
                          const EmptyStateWidget(),
                        ] else
                          ...jobs.map(
                            (job) => Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: TechnicianJobCard(job: _toUiModel(job)),
                            ),
                          ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
