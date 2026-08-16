import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/insert_technician_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsertTechnicianProfile extends StatelessWidget {
  const InsertTechnicianProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TechnicianProfileCubit>()),
        BlocProvider(create: (_) => getIt<TechnicianLocationCubit>()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: const CustomAppBar(title: 'إضافة فني', showBackButton: true),
          body: const ImageBackground(child: InsertTechnicianProfileBody()),
        ),
      ),
    );
  }
}
