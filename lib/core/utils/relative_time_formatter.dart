import 'package:car_care/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


String formatRelativeTime(BuildContext context, DateTime dateTime) {
  final strings = context.l10n;
  final diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) return strings.notificationJustNow;
  if (diff.inMinutes < 60) {
    return strings.notificationMinutesAgo(diff.inMinutes);
  }
  if (diff.inHours < 24) return strings.notificationHoursAgo(diff.inHours);
  if (diff.inDays == 1) return strings.notificationYesterday;
  if (diff.inDays < 7) return strings.notificationDaysAgo(diff.inDays);

  return DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
      .format(dateTime);
}
