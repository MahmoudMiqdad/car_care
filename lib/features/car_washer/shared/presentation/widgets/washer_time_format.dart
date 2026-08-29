import 'package:car_care/l10n.dart';
import 'package:flutter/widgets.dart';

String formatWasherTime12Hour(BuildContext context, String rawTime) {
  final parts = rawTime.split(':');
  if (parts.length < 2) return rawTime;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null || hour < 0 || hour > 23) {
    return rawTime;
  }

  final l10n = context.l10n;
  final period = hour == 12
      ? l10n.timePeriodNoon
      : hour < 12
      ? l10n.timePeriodAm
      : l10n.timePeriodPm;
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  final minuteStr = minute.toString().padLeft(2, '0');

  return '$hour12:$minuteStr $period';
}
