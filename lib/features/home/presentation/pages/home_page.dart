import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_body.dart';
import 'package:car_care/features/user_profile/presentation/cubit/show_profile_cubit/show_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShowProfileCubit>()..getProfile(),
      // ⬅️ الهوم هي جذر التطبيق (أول تاب) — هون بس منحمي زر الرجوع
      // بـ "اضغط مرتين للخروج" بدل ما يطلع فورًا من أول ضغطة.
      child: const DoubleBackToExitWrapper(
        child: Scaffold(
          body: ImageBackground(
            child: HomeBody(),
          ),
        ),
      ),
    );
  }
}
