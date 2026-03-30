import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_entry.dart';
import 'package:car_care/features/vehicle/presentation/widgets/maintenance_history/maintenance_history_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceHistoryBody extends StatelessWidget {
  const MaintenanceHistoryBody({
    super.key,
    required this.vehicleId,
  });

  final int vehicleId;

  List<MaintenanceHistoryEntry> entriesForVehicle(int id) {
    return [
      MaintenanceHistoryEntry(
        description: 'تغيير زيت و فلتر',
        date: DateTime(2001, 1, 1),
        part: 'فلتر زيت',
        technicianName: 'خالد الخالد',
      ),
      MaintenanceHistoryEntry(
        description: 'تغيير طرينة',
        date: DateTime(2011, 4, 1),
        part: 'طرينة بنزين',
        technicianName: 'محمد العلي',
      ),
      MaintenanceHistoryEntry(
        description: 'تغيير أضوية',
        date: DateTime(2012, 2, 4),
        part: 'أضوية أمامية',
        technicianName: 'حسن الحمد',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final entries = entriesForVehicle(vehicleId);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w,40.h,16.w, 20.h),
          sliver: SliverList.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return MaintenanceHistoryItemCard(entry: entries[index]);
            },
          ),
        ),
      ],
    );
  }
}
