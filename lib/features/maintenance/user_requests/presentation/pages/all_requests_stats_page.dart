import 'package:car_care/features/maintenance/user_requests/domain/request_status.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/pages/all_requests.dart';
import 'package:car_care/features/technician/technician_order/presentation/cubit/request_cubit/request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/cubit/show_requests_cubit.dart';


class AllRequestsStatsPage extends StatelessWidget {
  const AllRequestsStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RequestsCubit>()
        ..fetch(RequestStatus.pending), 
      child: AllRequestsPage(),
    );
  }
}