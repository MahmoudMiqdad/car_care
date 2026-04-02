import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'maintenance_history_entry.dart';
import 'maintenance_history_item_card.dart';

class MaintenanceHistoryBody extends StatelessWidget {
  const MaintenanceHistoryBody({super.key, required this.vehicleId});
  final int vehicleId;
  List<MaintenanceHistoryEntry> _getMockData() {
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
    final entries = _getMockData();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          sliver: SliverList.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return MaintenanceHistoryItemCard(entry: entries[index]);
            },
          ),
        ),
      ],
    );
  }
}