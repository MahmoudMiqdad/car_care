import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_body.dart';
import 'package:car_care/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<NotificationsCubit>().fetchUnreadCount();
    return BlocProvider(
      create: (_) => getIt<ShowProfileCubit>()..getProfile(),
      child: BlocListener<ShowProfileCubit, ShowProfileState>(
        listener: (context, state) {
          if (state is ShowProfileLoaded) {
            getIt<NotificationsCubit>().subscribeRealtime(state.profile.id);
          }
        },
        child: const DoubleBackToExitWrapper(
          child: Scaffold(body: ImageBackground(child: HomeBody())),
        ),
      ),
    );
  }
}
