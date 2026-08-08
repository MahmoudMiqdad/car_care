import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/home/presentation/widgets/ServicesGrid.dart';
import 'package:car_care/features/home/presentation/widgets/active_orderCard.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            BlocBuilder<ShowProfileCubit, ShowProfileState>(
              builder: (context, state) {
                final name = state is ShowProfileLoaded ? state.profile.name : '...';
                return AppText.headline(context, 'مرحباً، $name');
              },
            ),
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
        context.go(Routes.addRequest);
        break;
      case 2:
        context.go(Routes.washers);
        break;
      case 3:
        context.go(Routes.allUserSosRequests);
        break;
      case 4:
        context.go(Routes.customerAllProducts);
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
