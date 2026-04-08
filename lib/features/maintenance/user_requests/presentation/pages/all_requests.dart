import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cubit/show_requests_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cubit/show_requests_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/all_requests_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AllRequestsPage extends StatefulWidget {
  const AllRequestsPage({super.key});

  @override
  State<AllRequestsPage> createState() => _AllRequestsPageState();
}

class _AllRequestsPageState extends State<AllRequestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<RequestsCubit>();
      cubit.fetch(RequestStatus.pending);

      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;

        switch (_tabController.index) {
          case 0:
            cubit.fetch(RequestStatus.pending);
            break;
          case 1:
            cubit.fetch(RequestStatus.accepted);
            break;
          case 2:
            cubit.fetch(RequestStatus.completed);
            break;
          case 3:
            cubit.fetch(RequestStatus.all);
            break;
        }

        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SizedBox(
        height: 45.h,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: const BoxDecoration(),
          dividerColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
          tabs: [
            _buildTab('Pending', 0),
            _buildTab('Accepted', 1),
            _buildTab('Completed', 2),
            _buildTab('All', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: BlocBuilder<RequestsCubit, RequestsState>(
        key: ValueKey(_currentIndex),
        builder: (context, state) {
          if (state is RequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RequestsError) {
            return Center(child: Text(state.message));
          }

          if (state is RequestsLoaded) {
           final jobs = state.response.data;
         

            if (jobs!.isEmpty) {
              return const Center(child: Text("لا يوجد طلبات"));
            }

            return AllRequestsTabContent(jobs: jobs);
          }

          return const SizedBox();
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
              color: selected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.lightBorder,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
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
                color: selected
                    ? Colors.white
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}