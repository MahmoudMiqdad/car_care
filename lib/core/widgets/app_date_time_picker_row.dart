import 'package:car_care/core/widgets/app_outlined_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDateTimePickerRow extends StatelessWidget {
  const AppDateTimePickerRow({
    super.key,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    required this.onTimeTap,
    this.spacing,
  });

  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: AppOutlinedSelectField(
            valueText: dateText,
            onTap: onDateTap,
          ),
        ),
        SizedBox(width: spacing ?? 12.w),
        Expanded(
          child: AppOutlinedSelectField(
            valueText: timeText,
            onTap: onTimeTap,
          ),
        ),
      ],
    );
  }
}
