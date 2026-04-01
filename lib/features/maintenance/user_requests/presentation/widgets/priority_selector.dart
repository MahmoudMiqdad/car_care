import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/request_priority_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MaintenancePriority selected;
  final ValueChanged<MaintenancePriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle('إختيار الأولوية'),
        SizedBox(height: 12.h),
        Row(
          children: [
            for (final priority in MaintenancePriority.values) ...[
              Expanded(
                child: RequestPriorityChip(
                  label: priority.labelAr,
                  style: PriorityChipStyle.forState(
                    value: priority,
                    selected: selected,
                  ),
                  onTap: () => onChanged(priority),
                ),
              ),
              if (priority != MaintenancePriority.values.last) 
                SizedBox(width: 8.w),
            ],
          ],
        ),
      ],
    );
  }
}