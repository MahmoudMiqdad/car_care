import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Filter option keys in display order — `null` is "الكل" (sent to the API
/// as no filter at all). Single source of truth for both the customer and
/// washer booking filters (previously two separate, near-identical copies).
const List<String?> carwashBookingFilterStatusKeys = [
  null,
  'pending',
  'accepted',
  'in_progress',
  'completed',
  'cancelled',
];

/// Same translated labels for both sides, keyed the same way as
/// [carwashBookingFilterStatusKeys].
Map<String?, String> carwashBookingFilterLabels(AppLocalizations l10n) {
  return {
    null: 'الكل',
    'pending': l10n.bookingStatusPending,
    'accepted': l10n.bookingStatusAccepted,
    'in_progress': l10n.bookingStatusProgress,
    'completed': l10n.bookingStatusCompleted,
    'cancelled': l10n.bookingStatusCanceled,
  };
}

/// The carwash booking status filter — one shared implementation for both
/// the customer and washer booking lists. Deliberately Cubit-agnostic: it
/// only knows the currently-selected status and a callback, so callers
/// (`CustomerBookingFilter`/`WasherBookingFilter`) stay thin wrappers that
/// read their own Cubit's state and forward `fetchBookings`.
class CarwashBookingFilter extends StatelessWidget {
  const CarwashBookingFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  /// `null` means "الكل" (no filter applied).
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelsByKey = carwashBookingFilterLabels(l10n);
    final statuses = {
      for (final key in carwashBookingFilterStatusKeys) key: labelsByKey[key]!,
    };

    return PopupMenuButton<String?>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: AppColors.primary, width: 1),
      ),
      elevation: 6,
      color: AppColors.white,
      itemBuilder: (_) {
        return statuses.entries.map((entry) {
          final isSelected = entry.key == selectedStatus;
          return PopupMenuItem<String?>(
            value: entry.key,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary, width: 1.3),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.black,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                statuses[selectedStatus] ?? 'الكل',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
