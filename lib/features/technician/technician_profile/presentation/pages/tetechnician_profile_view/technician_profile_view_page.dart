import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_availability_cubit/technician_availability_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_view_body%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianProfileViewPage extends StatelessWidget {
  const TechnicianProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<TechnicianProfileCubit>()..getTechnicianProfile(),
        ),
        BlocProvider(create: (_) => getIt<TechnicianAvailabilityCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: const CustomAppBar(title: 'الملف الفني', showBackButton: true),
        body: const ImageBackground(child: TechnicianProfileViewBody()),
      ),
    );
  }
}
