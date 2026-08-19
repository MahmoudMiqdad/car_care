
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/floating_add_button.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_requests/domain/entities/maintenance_request_entity.dart';
import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show/show_requests_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/show/show_requests_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/all_requests_tab_content.dart';
import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
 // تأكد من المسار الصحيح للـ Entity


class AllRequestsPage extends StatefulWidget {
  const AllRequestsPage({super.key});
  @override
  State<AllRequestsPage> createState() => _AllRequestsPageState();
}

class _AllRequestsPageState extends State<AllRequestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  final Map<RequestStatus, MaintenanceRequestEntity> _cache = {};

  static RequestStatus _statusForIndex(int index) {
    switch (index) {
      case 1:
        return RequestStatus.accepted;
      case 2:
        return RequestStatus.completed;
      case 3:
        return RequestStatus.all;
      case 0:
      default:
        return RequestStatus.pending;
    }
  }

  RequestStatus get _currentStatus => _statusForIndex(_currentIndex);

  Future<void> _refreshCurrentTab() {
    return context.read<RequestsCubit>().fetch(_currentStatus);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() {
        _currentIndex = _tabController.index;
      });
      context.read<RequestsCubit>().fetch(_currentStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; 

    return Scaffold(
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
        title: l10n.providerMyOrdersTitle, 
        showBackButton: true,
        onBackTapped: () => context.go(Routes.home),
      ),
      body: ImageBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTabs(l10n), 
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SizedBox(
        height: 45.h,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: const BoxDecoration(),
          dividerColor: AppColors.transparent, 
          labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
          tabs: [
            _buildTab(l10n.pending, 0), 
            _buildTab(l10n.bookingStatusAccepted, 1),
            _buildTab(l10n.bookingStatusCompleted, 2), 
            _buildTab(l10n.all, 3), 
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: BlocConsumer<RequestsCubit, RequestsState>(
        key: ValueKey(_currentIndex),
        listener: (context, state) {
          if (state is RequestsLoaded) {
            _cache[state.status] = state.response;
          }
        },
        builder: (context, state) {
          final cached = _cache[_currentStatus];

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

  Widget _buildTab(String text, int index) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        final selected = _tabController.index == index;

        return GestureDetector(
          onTap: () => _tabController.animateTo(index),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border(context),
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2), 
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: selected ? 15.sp : 14.sp,
                fontWeight: FontWeight.w800,
                color: selected ? AppColors.white : AppColors.textSecondary(context), 
              ),
            ),
          ),
        );
      },
    );
  }
}
