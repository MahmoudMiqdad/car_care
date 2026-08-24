import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/app_outlined_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateProfileWasherWorkHoursSection extends StatelessWidget {
  const CreateProfileWasherWorkHoursSection({
    super.key,
    required this.sectionTitle,
    required this.startLabel,
    required this.startHint,
    required this.endLabel,
    required this.endHint,
    required this.startController,
    required this.endController,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
    this.enabled = true,
  });

  final String sectionTitle;
  final String startLabel;
  final String startHint;
  final String endLabel;
  final String endHint;
  final TextEditingController startController;
  final TextEditingController endController;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          context,
          sectionTitle,
          color: context.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _WorkTimeField(
                label: startLabel,
                hint: startHint,
                controller: startController,
                onTap: enabled ? onStartTimeTap : null,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _WorkTimeField(
                label: endLabel,
                hint: endHint,
                controller: endController,
                onTap: enabled ? onEndTimeTap : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkTimeField extends StatelessWidget {
  const _WorkTimeField({
    required this.label,
    required this.hint,
    required this.controller,
    this.onTap,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            label,
            style: context.textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final display = controller.text.trim().isEmpty
                ? hint
                : controller.text.trim();
            return AppOutlinedSelectField(
              valueText: display,
              onTap: onTap ?? () {},
            );
          },
        ),
      ],
    );
  }
}

TimeOfDay profileWasherParseWorkTime(String text, {TimeOfDay? fallback}) {
  final raw = text.trim();
  if (raw.isEmpty) return fallback ?? const TimeOfDay(hour: 9, minute: 0);

  final segment = raw.contains('-') ? raw.split('-').first.trim() : raw;
  final parts = segment.split(':');
  if (parts.length >= 2) {
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }
  return fallback ?? const TimeOfDay(hour: 9, minute: 0);
}

String profileWasherFormatWorkTime(TimeOfDay time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

Future<void> profileWasherPickWorkTime(
  BuildContext context, {
  required TextEditingController controller,
  TimeOfDay? initial,
}) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: profileWasherParseWorkTime(controller.text, fallback: initial),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: AppColors.carWashTeal),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    controller.text = profileWasherFormatWorkTime(picked);
  }
}
