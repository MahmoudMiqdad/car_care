import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/pages/widgets/technician_profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianProfileViewPage extends StatelessWidget {
  const TechnicianProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
           create: (_) => getIt<TechnicianProfileCubit>()..getTechnicianProfile(),
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: AppBar(
          title: const Text('الملف الفني'),
        ),
        body: const TechnicianProfileViewBody(),
      ),
    );
  }
}