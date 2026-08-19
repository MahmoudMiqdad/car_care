import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/technician_sos/presentation/cubit/technician_sos_cubit/technician_sos_cubit.dart';
import 'package:car_care/features/technician_sos/presentation/widgets/sos_requests_list/technician_sos_requests_list_page.dart'; // 🎯 تحديث المسار الموحد للـ enum والـ Page
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTechnicianSosRequests extends StatelessWidget {
  const AllTechnicianSosRequests({
    super.key,
    this.type = SosRequestType.available,
  });

  final SosRequestType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TechnicianSosCubit>(),
      child: TechnicianSosRequestsListPage(type: type),
    );
  }
}
