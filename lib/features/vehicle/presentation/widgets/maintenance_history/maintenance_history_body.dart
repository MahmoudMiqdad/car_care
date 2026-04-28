import 'package:car_care/core/widgets/loding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'maintenance_history_item_card.dart';
import 'package:car_care/features/vehicle/presentation/cubit/maintenance_history/maintenance_history_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/maintenance_history/maintenance_history_state.dart';

class MaintenanceHistoryBody extends StatelessWidget {
  const MaintenanceHistoryBody({super.key, required this.vehicleId});
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceHistoryCubit, MaintenanceHistoryState>(
      builder: (context, state) {
        if (state is MaintenanceHistoryLoading) {
          return const Center(child: AppLoadingWidget());
        }

        if (state is MaintenanceHistoryFailure) {
          return Center(child: Text(state.message));
        }

        if (state is MaintenanceHistorySuccess) {
          final entries = state.items;

          if (entries.isEmpty) {
            return const Center(child: Text('لا يوجد سجلات صيانة'));
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                sliver: SliverList.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return MaintenanceHistoryItemCard(entry: entries[index]);
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
