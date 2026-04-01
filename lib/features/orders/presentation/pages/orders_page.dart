import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/orders/presentation/models/order_list_item.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/orders/presentation/widgets/orders_page/orders_list_view.dart';
import 'package:car_care/features/vehicle/presentation/widgets/MyVehicles/RefreshHint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<OrderListItem> _items;

  @override
  void initState() {
    super.initState();
    _items = _sampleOrders;
  }

  void _onRefresh() {
    setState(() {
      _items = List<OrderListItem>.from(_sampleOrders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: const CustomAppBar(
          title: 'Orders',
          showBackButton: true,
        ),
        bottomNavigationBar: HomeBottomNavBar(
          activeIndex: -1,
          onItemSelected: (index) {
            if (index == 0) {
              context.go(Routes.home);
            }
          },
        ),
        body: ImageBackground(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 12.w,
                    end: 12.w,
                    top: 8.h,
                  ),
                  child: RefreshHint(
                    hintText: 'تحديث سجل الطلبات ...',
                    onTap: _onRefresh,
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: OrdersListView(
                    items: _items,
                    onOrderTap: (item) {
                      context.push(Routes.order_details, extra: item.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final List<OrderListItem> _sampleOrders = [
  OrderListItem(
    id: '1',
    description: 'عطل في الكولاس',
    customerName: 'خالد الحميدات',
    vehicleInfo: 'سابا سيدان 130',
    date: DateTime(2026, 8, 8),
    priority: MaintenancePriority.urgent,
    imageAssetPath: AppAssets.maintenanceIcon,
  ),
  OrderListItem(
    id: '2',
    description: 'كسر في الزجاج الخلفي',
    customerName: 'سارة محمد',
    vehicleInfo: 'هيونداي النترا 2019',
    date: DateTime(2026, 7, 15),
    priority: MaintenancePriority.medium,
    imageAssetPath: AppAssets.serviceMaintenance,
  ),
  OrderListItem(
    id: '3',
    description: 'انخفاض ضغط الإطارات',
    customerName: 'أحمد علي',
    vehicleInfo: 'كيا ريو 2020',
    date: DateTime(2026, 6, 3),
    priority: MaintenancePriority.low,
    imageAssetPath: AppAssets.serviceSos,
  ),
];
