import 'package:car_care/core/service_locator/service_locator.dart';
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
    // Same NotificationsCubit singleton provided at the app root; this just
    // triggers the initial unread-count fetch that feeds the nav bar badge.
    getIt<NotificationsCubit>().fetchUnreadCount();
    return BlocProvider(
      create: (_) => getIt<ShowProfileCubit>()..getProfile(),
      child: BlocListener<ShowProfileCubit, ShowProfileState>(
        // The authenticated user's id is only available once /auth/me
        // resolves — this is the smallest reuse of an existing fetch that
        // already runs on every Home load, rather than adding a new
        // network call just to learn the id for the realtime channel.
        listener: (context, state) {
          if (state is ShowProfileLoaded) {
            getIt<NotificationsCubit>().subscribeRealtime(state.profile.id);
          }
        },
        child: const Scaffold(
          body: ImageBackground(
            child: HomeBody(),
          ),
        ),
      ),
    );
  }
}
