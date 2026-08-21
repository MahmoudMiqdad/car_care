import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart'; 
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/request_priority_chip.dart';
import 'package:car_care/l10n.dart'; 
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
    final l10n = context.l10n; 
    final r = AppConstants.maintenanceRequestCardRadius.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(context, l10n.selectPriorityTitle), 
        SizedBox(height: 3.h),
        Row(
          children: [
            for (final priority in MaintenancePriority.values) ...[
              Expanded(
                child: Material(
                  color: AppColors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(r),
                    onTap: () => onChanged(priority),
                    child: RequestPriorityChip(
                      label: priority.localizedLabel(context),
                      style: PriorityChipStyle.forState(
                        context: context, 
                        value: priority,
                        selected: selected,
                      ),
                    ),
                  ),
                ),
              ),
              if (priority != MaintenancePriority.values.last) 
                SizedBox(width: 5.w),
            ],
          ],
        ),
      ],
    );
  }
}
