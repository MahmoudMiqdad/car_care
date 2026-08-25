import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileBody.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShowProfileCubit>()..getProfile(),

      child: PopScope(
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.go(Routes.home);
        },
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          body: ImageBackground(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ProfileBody(),
                PositionedDirectional(
                  top: 0,
                  start: 4,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () => context.safePopOrGo(Routes.home),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black26,
                      ),
                      tooltip: context.l10n.back,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
