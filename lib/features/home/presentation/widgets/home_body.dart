// مسؤول عن عرض محتوى الصفحة الرئيسية للعميل: إعلانات المنزل وشبكة الخدمات.
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_section.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/home_palette.dart';
import 'package:car_care/l10n.dart'; // 🎯 استيراد امتداد l10n للترجمة الديناميكية
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  static const double _advertisementHeight = 185;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdvertisementSection(
              placement: AdvertisementPlacement.home,
              height: _advertisementHeight,
              borderRadius: 20,
              bottomSpacing: 24,
            ),
            Center(
              child: Text(
                l10n.homeWelcomeGreeting,
                style: TextStyle(
                  color: HomePalette.primaryTeal,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 14.h),
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
        context.push(Routes.my_vehicles_page);
        break;
      case 1:
        context.push(Routes.all_requests);
        break;
      case 2:
        context.push(Routes.washers);
        break;
      case 3:
        context.push(Routes.allUserSosRequests);
        break;
      case 4:
        context.push(Routes.customerShopsList);
        break;
      case 5:
        context.push(Routes.fuelorderslist);
        break;
      default:
        debugPrint("No route defined for index $index");
    }
  }
}
