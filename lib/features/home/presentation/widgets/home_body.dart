// مسؤول عن عرض محتوى الصفحة الرئيسية للعميل: إعلانات المنزل وشبكة الخدمات.
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_section.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdvertisementSection(
              placement: AdvertisementPlacement.home,
              height: 160,
              borderRadius: 16,
              bottomSpacing: 24,
            ),
            ServicesGrid(
              onItemPressed: (index) => onServicePressed(context, index),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void onServicePressed(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.my_vehicles_page);
        break;
      case 1:
        // "الصيانة" -> customer requests list (its FAB creates a new request)
        context.go(Routes.all_requests);
        break;
      case 2:
        context.go(Routes.washers);
        break;
      case 3:
        context.go(Routes.allUserSosRequests);
        break;
      case 4:
        context.go(Routes.customerShopsList);
        break;
      case 5:
        // "الوقود" -> customer fuel orders list (its FAB creates a new order)
        context.go(Routes.fuelorderslist);
        break;
      default:
        debugPrint("No route defined for index $index");
    }
  }
}
