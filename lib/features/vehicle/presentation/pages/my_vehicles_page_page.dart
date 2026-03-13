import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/vehicle/presentation/widgets/VehiclesBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyVehiclesPagePage extends StatelessWidget {
  const MyVehiclesPagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(64.h),
          child: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,

          leading: Padding(
  padding: EdgeInsets.only(left: 8.w, right: 7),
  child: Container(
    width: 36.w,
    height: 36.w,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: () => context.go(Routes.add_vehicle),
      icon: const Icon(
        Icons.add,
        color: AppColors.primary,
        size: 24,
      ),
      splashRadius: 18,
    ),
  ),
),

            centerTitle: true,
            title: Text(
              'My Vehicles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

          actions: [
  Directionality(
    textDirection: TextDirection.ltr,
    child: IconButton(
      onPressed: () =>     context.go(Routes.home),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 4.w),
          Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  ),
],
          ),
        ),

        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.artboardBackground,
              fit: BoxFit.cover,
            ),
            const VehiclesBody(),
          ],
        ),

        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) {
              context.go(Routes.home);
            }
          },
        ),
      ),
    );
  }
}