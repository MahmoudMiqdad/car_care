import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileBody.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
    );
  }
}