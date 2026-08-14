import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_jobs/domain/entities/technician_jobs_entity.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_state.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/complete_job_dialog.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/technician_job_card.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class _TechnicianJobsBody extends StatefulWidget {
  const _TechnicianJobsBody();

  @override
  State<_TechnicianJobsBody> createState() => _TechnicianJobsBodyState();
}

class _TechnicianJobsBodyState extends State<_TechnicianJobsBody> {
  /// ServiceJob id currently being updated — only that card shows a busy
  /// button, and duplicate taps on it are blocked.
  String? _busyJobId;

  /// Last loaded jobs, so a per-card action never blanks the list.
  List<JobEntity> _jobs = const [];
  bool _hasLoaded = false;

  /// Maps the backend job status to the card's colour bucket + Arabic label.
  static (TechnicianJobCardStatus, String) _statusOf(String status) {
    return switch (status.toLowerCase()) {
      'rejected' ||
      'cancelled' ||
      'canceled' => (TechnicianJobCardStatus.rejected, 'ملغي'),
      'completed' => (TechnicianJobCardStatus.waiting, 'مكتمل'),
      'in_progress' ||
      'in-progress' => (TechnicianJobCardStatus.waiting, 'قيد التنفيذ'),
      'assigned' => (TechnicianJobCardStatus.waiting, 'مُسند'),
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
      priceOffer: job.quotationPrice == null ? null : '\$${job.quotationPrice}',
    );
  }

  /// PATCH /technician/jobs/{ServiceJob id}/status  { "status": "in_progress" }
  void _startJob(JobEntity job) {
    if (_busyJobId != null) return;
    setState(() => _busyJobId = job.id.toString());
    context.read<TechnicianJobsCubit>().updateJobStatus({
      'status': 'in_progress',
    }, job.id.toString());
  }

  /// PATCH /technician/jobs/{ServiceJob id}/status
  /// { "status": "completed", "completion_notes": "..." }
  Future<void> _completeJob(JobEntity job) async {
    if (_busyJobId != null) return;

    final cubit = context.read<TechnicianJobsCubit>();
    final notes = await showCompleteJobDialog(context);
    if (notes == null || !mounted) return;

    setState(() => _busyJobId = job.id.toString());
    await cubit.updateJobStatus({
      'status': 'completed',
      'completion_notes': notes,
    }, job.id.toString());
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
        body: ImageBackground(
          child: SafeArea(
            child: BlocConsumer<TechnicianJobsCubit, TechnicianJobsState>(
              listener: (context, state) {
                if (state is TechnicianJobsLoaded) {
                  setState(() {
                    _jobs = state.jobs.jobs;
                    _hasLoaded = true;
                  });
                }
                if (state is JobStatusUpdated) {
                  setState(() => _busyJobId = null);
                  final msg = state.data.message.trim();
                  AppSnackBar.success(
                    context,
                    msg.isEmpty ? 'تم تحديث حالة المهمة بنجاح' : msg,
                  );
                  cubit.fetchMyJobs();
                }
                if (state is JobStatusError) {
                  setState(() => _busyJobId = null);
                  final msg =
                      state.message.isEmpty ||
                          state.message.startsWith('Instance of')
                      ? 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى'
                      : state.message;
                  AppSnackBar.error(context, msg);
                }
              },
              builder: (context, state) {
                // Full loader only for the very first load.
                if (state is TechnicianJobsLoading && !_hasLoaded) {
                  return const Center(child: AppLoadingWidget());
                }

                if (state is TechnicianJobsError) {
                  return ErrorStateWidget(
                    message:
                        state.message.isEmpty ||
                            state.message.startsWith('Instance of')
                        ? 'حدث خطأ أثناء تحميل الأعمال'
                        : state.message,
                    onRetry: cubit.fetchMyJobs,
                  );
                }

                if (!_hasLoaded) return const SizedBox.shrink();

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
                      if (_jobs.isEmpty) ...[
                        SizedBox(height: 40.h),
                        const EmptyStateWidget(),
                      ] else
                        ..._jobs.map(
                          (job) => Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: TechnicianJobCard(
                              job: _toUiModel(job),
                              rawStatus: job.status,
                              isBusy: _busyJobId == job.id.toString(),
                              onStart: () => _startJob(job),
                              onComplete: () => _completeJob(job),
                            ),
                          ),
                        ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
