
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/filters/status_filter_tabs.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show/show_requests_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show/show_requests_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/all_requests_tab_content.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AllRequestsPage extends StatefulWidget {
  const AllRequestsPage({super.key});
  @override
  State<AllRequestsPage> createState() => _AllRequestsPageState();
}

class _AllRequestsPageState extends State<AllRequestsPage> {
  RequestStatus _currentStatus = RequestStatus.pending;

  /// Last loaded response per tab, so a pull-to-refresh or return-refresh
  /// never blanks an already loaded tab back to a full-page loader.
  final Map<RequestStatus, MaintenanceRequestEntity> _cache = {};

  Future<void> _refreshCurrentTab() {
    return context.read<RequestsCubit>().fetch(_currentStatus);
  }

  void _onStatusChanged(RequestStatus status) {
    if (status == _currentStatus) return;
    setState(() => _currentStatus = status);
    context.read<RequestsCubit>().fetch(_currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 16.h, left: 16.w),
          child: FloatingAddButton(
            onTap: () async {
              await context.push(Routes.addRequest);
              if (!mounted) return;
              _refreshCurrentTab();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CustomAppBar(
          title: 'All Requests',
          showBackButton: true,
          onBackTapped: () => context.go(Routes.home),
        ),
        body: ImageBackground(
          child: SafeArea(
            child: Column(
              children: [
                _buildTabs(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: StatusFilterTabs<RequestStatus>(
        items: [
          StatusFilterTabItem(
            value: RequestStatus.pending,
            label: l10n.requestStatusPending,
          ),
          StatusFilterTabItem(
            value: RequestStatus.accepted,
            label: l10n.requestStatusAccepted,
          ),
          StatusFilterTabItem(
            value: RequestStatus.completed,
            label: l10n.requestStatusCompleted,
          ),
          StatusFilterTabItem(
            value: RequestStatus.all,
            label: l10n.requestStatusAll,
          ),
        ],
        selected: _currentStatus,
        onChanged: _onStatusChanged,
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: BlocConsumer<RequestsCubit, RequestsState>(
        key: ValueKey(_currentStatus),
        listener: (context, state) {
          if (state is RequestsLoaded) {
            _cache[state.status] = state.response;
          }
        },
        builder: (context, state) {
          final cached = _cache[_currentStatus];

          // Only the very first load of a tab (no cached data yet) shows the
          // full-page loader/error state; a pull-to-refresh or return-refresh
          // keeps the previously loaded list visible while it runs.
          if (state is RequestsLoading && cached == null) {
            return const Center(child: AppLoadingWidget());
          }

          if (state is RequestsError && cached == null) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300.h,
                  child: Center(child: Text(state.message)),
                ),
              ],
            );
          }

          final jobs = state is RequestsLoaded
              ? state.response.data
              : cached?.data ?? const [];

          return RefreshIndicator(
            onRefresh: _refreshCurrentTab,
            child: jobs.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 300.h, child: const EmptyStateWidget()),
                    ],
                  )
                : AllRequestsTabContent(
                    jobs: jobs,
                    onReturnFromDetails: _refreshCurrentTab,
                  ),
          );
        },
      ),
    );
  }
}
