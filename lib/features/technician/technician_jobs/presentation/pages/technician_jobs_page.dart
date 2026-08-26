import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/technician/technician_jobs/domain/entities/technician_jobs_entity.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_cubit.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/cubit/technician_jobs_state.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/complete_job_dialog.dart';
import 'package:car_care/features/technician/technician_jobs/presentation/widgets/technician_job_card.dart';
import 'package:car_care/l10n.dart';
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

const List<String> _kJobStatusFilterKeys = [
  'assigned',
  'in_progress',
  'completed',
];

class _TechnicianJobsBodyState extends State<_TechnicianJobsBody> {
  String? _busyJobId;
  List<JobEntity> _jobs = const [];
  bool _hasLoaded = false;
  String? _selectedStatus;

  bool _matchesFilter(String rawStatus) {
    if (_selectedStatus == null) return true;
    final normalized = rawStatus.toLowerCase();
    return switch (_selectedStatus) {
      'in_progress' =>
        normalized == 'in_progress' || normalized == 'in-progress',
      _ => normalized == _selectedStatus,
    };
  }

  String _filterLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'assigned' => l10n.jobAssignedStatusLabel,
      'in_progress' => l10n.processingStatusLabel,
      'completed' => l10n.bookingStatusCompleted,
      _ => key,
    };
  }

  (TechnicianJobCardStatus, String) _statusOf(
    BuildContext context,
    String status,
  ) {
    final l10n = context.l10n;
    return switch (status.toLowerCase()) {
      'rejected' || 'cancelled' || 'canceled' => (
        TechnicianJobCardStatus.rejected,
        l10n.bookingStatusCanceled,
      ),
      'completed' => (
        TechnicianJobCardStatus.waiting,
        l10n.bookingStatusCompleted,
      ),
      'in_progress' || 'in-progress' => (
        TechnicianJobCardStatus.waiting,
        l10n.processingStatusLabel,
      ),
      'assigned' => (
        TechnicianJobCardStatus.waiting,
        l10n.jobAssignedStatusLabel,
      ),
      'accepted' => (
        TechnicianJobCardStatus.waiting,
        l10n.bookingStatusAccepted,
      ),
      _ => (TechnicianJobCardStatus.waiting, l10n.pending),
    };
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}/${date.month}/${date.day}';
  }

  TechnicianJobUiModel _toUiModel(BuildContext context, JobEntity job) {
    final (cardStatus, label) = _statusOf(context, job.status);
    return TechnicianJobUiModel(
      status: cardStatus,
      statusLabel: label,
      description: job.description.isEmpty ? '-' : job.description,
      customerName: job.customerName.isEmpty ? '-' : job.customerName,
      vehicle: job.vehicleLabel,
      appointmentDate: _formatDate(job.scheduledDate),
      priceOffer: job.quotationPrice == null ? null : '\$${job.quotationPrice}',
    );
  }

  void _startJob(JobEntity job) {
    if (_busyJobId != null) return;
    setState(() => _busyJobId = job.id.toString());
    context.read<TechnicianJobsCubit>().updateJobStatus({
      'status': 'in_progress',
    }, job.id.toString());
  }

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
    final l10n = context.l10n;
    final cubit = context.read<TechnicianJobsCubit>();
    final filteredJobs = _jobs
        .where((job) => _matchesFilter(job.status))
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.myJobsTitle,
        showBackButton: true,
        fallbackRoute: Routes.more,
      ),
      body: ImageBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StatusFilterTabs<String?>(
                  items: [
                    StatusFilterTabItem(
                      value: null,
                      label: l10n.bookingStatusAll,
                    ),
                    for (final key in _kJobStatusFilterKeys)
                      StatusFilterTabItem(
                        value: key,
                        label: _filterLabel(context, key),
                      ),
                  ],
                  selected: _selectedStatus,
                  onChanged: (value) => setState(() => _selectedStatus = value),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<TechnicianJobsCubit>().fetchMyJobs(),
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
                          msg.isEmpty ? l10n.jobStatusUpdatedSuccess : msg,
                        );
                        cubit.fetchMyJobs();
                      }
                      if (state is JobStatusError) {
                        setState(() => _busyJobId = null);
                        final msg =
                            state.message.isEmpty ||
                                state.message.startsWith('Instance of')
                            ? l10n.unexpectedErrorTryAgain
                            : state.message;
                        AppSnackBar.error(context, msg);
                      }
                    },
                    builder: (context, state) {
                      if (state is TechnicianJobsLoading && !_hasLoaded) {
                        return const Center(child: AppLoadingWidget());
                      }

                      if (state is TechnicianJobsError) {
                        return ErrorStateWidget(
                          message:
                              state.message.isEmpty ||
                                  state.message.startsWith('Instance of')
                              ? l10n.jobLoadErrorLabel
                              : state.message,
                          onRetry: cubit.fetchMyJobs,
                        );
                      }

                      if (!_hasLoaded) return const SizedBox.shrink();

                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        children: [
                          if (filteredJobs.isEmpty) ...[
                            SizedBox(height: 40.h),
                            const EmptyStateWidget(),
                          ] else
                            ...filteredJobs.map(
                              (job) => Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: TechnicianJobCard(
                                  job: _toUiModel(context, job),
                                  rawStatus: job.status,
                                  isBusy: _busyJobId == job.id.toString(),
                                  onStart: () => _startJob(job),
                                  onComplete: () => _completeJob(job),
                                ),
                              ),
                            ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
