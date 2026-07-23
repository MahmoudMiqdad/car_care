
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/cubit/provider_order_cubit.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_available_orders_page.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_order/presentation/pages/provider_order_page.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProviderOrdersTabsWrapper extends StatelessWidget {
  const ProviderOrdersTabsWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FuelProviderOrderCubit>(),
      child: const ProviderOrdersTabsPage(),
    );
  }
}

class ProviderOrdersTabsPage extends StatefulWidget {
  const ProviderOrdersTabsPage({super.key});

  @override
  State<ProviderOrdersTabsPage> createState() => _ProviderOrdersTabsPageState();
}

class _ProviderOrdersTabsPageState extends State<ProviderOrdersTabsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<FuelProviderOrderCubit>();
      cubit.getMyOrders();

      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;

        setState(() => _currentIndex = _tabController.index);

        if (_tabController.index == 0) {
          cubit.getMyOrders();
        } else {
          cubit.getAvailableOrders();
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;


    final titles = [
      l10n.providerMyOrdersTitle,
      l10n.providerAvailableOrdersTitle,
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: titles[_currentIndex], 
        showBackButton: true,
        onBackTapped: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(Routes.home);
          }
        },
      ),
      body: ImageBackground(
        child: SafeArea(
          child: Column(
            children: [
   
              Padding(
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
                      _buildTab(l10n.providerMyOrdersTitle, 0),
                      _buildTab(l10n.providerAvailableOrdersTitle, 1),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ProviderOrderPage(),
                    ProviderAvailableOrdersPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                color: selected ? AppColors.primary : AppColors.lightBorder,
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
                color: selected ? Colors.white : AppColors.lightTextSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}