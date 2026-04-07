import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/accepted_requests_widget.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/completed_requests_widget.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/get_all_requests_widget.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/all_requests/pending_requests_widget.dart';
import 'package:flutter/material.dart';
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
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_currentIndex != _tabController.index) {
        setState(() {
          _previousIndex = _currentIndex;
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'All  Requests',
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.h, 0, 4.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.lightBorder, width: 0.9),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.lightTextSecondary,
                    labelStyle: TextStyle(
                      fontSize: 16.6.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14.2.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 6.h),
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'Accepted'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Get all'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final bool isForward = _currentIndex >= _previousIndex;
                    final beginOffset = Offset(isForward ? 0.08 : -0.08, 0);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: beginOffset,
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(_currentIndex),
                    child: _tabBody(_currentIndex),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBody(int index) {
    switch (index) {
      case 0:
        return const PendingRequestsWidget();
      case 1:
        return const AcceptedRequestsWidget();
      case 2:
        return const CompletedRequestsWidget();
      default:
        return const GetAllRequestsWidget();
    }
  }
}
