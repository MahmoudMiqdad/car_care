import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherWorkHoursRow extends StatelessWidget {
  const EditProfileWasherWorkHoursRow({
    super.key,
    required this.startLabel,
    required this.startHint,
    required this.endLabel,
    required this.endHint,
    this.startController,
    this.endController,
  });

  final String startLabel;
  final String startHint;
  final String endLabel;
  final String endHint;
  final TextEditingController? startController;
  final TextEditingController? endController;

  @override
  Widget build(BuildContext context) {
    final clock = Icon(
      Icons.access_time_outlined,
      color: AppColors.carWashTeal,
      size: 22.sp,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: EditProfileWasherLabeledField(
            label: startLabel,
            hint: startHint,
            controller: startController,
            leadingIcon: clock,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: EditProfileWasherLabeledField(
            label: endLabel,
            hint: endHint,
            controller: endController,
            leadingIcon: clock,
          ),
        ),
      ],
    );
  }
}
