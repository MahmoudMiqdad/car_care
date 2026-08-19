import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/cubit/technician_location_cubit.dart';
import 'package:car_care/features/technician/technician_profile/domain/entities/technician_profile_entity.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/update_technician_profile.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TechnicianProfileEditPage extends StatelessWidget {
  final TechnicianDataEntity? initialData;

  const TechnicianProfileEditPage({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
      final string = context.l10n;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TechnicianProfileCubit>()),
        BlocProvider(create: (_) => getIt<TechnicianLocationCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar:  CustomAppBar(
          title: string.editTechnicianProfileLabel,
          showBackButton: true,
        ),
        body: ImageBackground(
          child: TechnicianProfileEditBodyContent(initialData: initialData),
        ),
      ),
    );
  }
}
