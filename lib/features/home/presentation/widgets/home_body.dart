import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/active_orderCard.dart';
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
            AppText.headline(context, 'Hello, Sami ...'),
            SizedBox(height: 16.h),
            const ActiveOrderCard(),
            SizedBox(height: 24.h),
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
        context.go(Routes.requests);
        break;
      default:
        debugPrint("No route defined for index $index");
    }
  }
}