import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_page/ProfileBody.dart';
import 'package:car_care/features/user_profile/presentation/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ShowProfileCubit>()..getProfile()),
        BlocProvider(create: (_) => getIt<AvatarCubit>()),
      ],
      child: PopScope(
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.go(Routes.home);
        },
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: CustomAppBar(
            title: context.l10n.myProfile,
            onBackTapped: () => context.safePopOrGo(Routes.home),
          ),
          body: const ImageBackground(child: ProfileBody()),
        ),
      ),
    );
  }
}
