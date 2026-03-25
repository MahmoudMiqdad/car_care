import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/profile/presentation/widgets/profile_page/ProfileBody.dart';
import 'package:car_care/features/profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,

      appBar: CustomAppBar(
        title: 'Profile',
        actionWidget: IconButton(
          onPressed: () {},
          icon: Icon(Icons.exit_to_app, color: Colors.white, size: 28.sp),
        ),
      ),

      body: BlocProvider(
        create: (_) => getIt<ShowProfileCubit>()..getProfile(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.artboardBackground,
              fit: BoxFit.cover,
            ),
            const ProfileBody(),
          ],
        ),
      ),

      bottomNavigationBar: HomeBottomNavBar(
        onItemSelected: (index) {},
      ),
    );
  }
}