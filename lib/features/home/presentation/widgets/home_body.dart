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
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 16.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.headline(context, 'Hello, Sami ...'),
          SizedBox(height: 16.h),
          const ActiveOrderCard(),
          SizedBox(height: 20.h),
          ServicesGrid(
            onItemPressed: (index) {
              if (index == 0) {
                context.go(Routes.my_vehicles_page);
              }
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

