import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

enum MaintenancePriority { low, medium, high }

String maintenanceRequestStatusLabel(
  BuildContext context,
  String? status, {
  String? fallback,
}) {
  final l10n = context.l10n;
  return switch (status) {
    'pending' || 'waiting' => l10n.requestStatusPending,
    'quotation_accepted' || 'accepted' => l10n.requestStatusAccepted,
    'in_progress' => l10n.sosInProgressStatus,
    'completed' => l10n.requestStatusCompleted,
    'cancelled' || 'canceled' => l10n.bookingStatusCanceled,
    'rejected' => l10n.rejectedStatusLabel,
    _ => fallback ?? status ?? '-',
  };
}

extension MaintenancePriorityLocalization on MaintenancePriority {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case MaintenancePriority.low:
        return l10n.priorityLow;
      case MaintenancePriority.medium:
        return l10n.priorityMedium;
      case MaintenancePriority.high:
        return l10n.priorityHigh;
    }
  }
}

@immutable
class PriorityChipStyle {
  const PriorityChipStyle({
    required this.background,
    required this.borderColor,
    required this.borderWidth,
    required this.textColor,
  });

  final Color background;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;

  static const double _defaultBorder = 1.2;
  static const double _selectedBorder = 2.0;

  static PriorityChipStyle forState({
    required BuildContext context,
    required MaintenancePriority value,
    required MaintenancePriority selected,
  }) {
    final isSelected = value == selected;
    final colorScheme = context.colorScheme;

    if (!isSelected) {
      return PriorityChipStyle(
        background: colorScheme.surfaceContainer,
        borderColor: AppColors.border(context),
        borderWidth: _defaultBorder,
        textColor: colorScheme.onSurface,
      );
    }

    switch (value) {
      case MaintenancePriority.low:
        return PriorityChipStyle(
          background: AppColors.green.withValues(alpha: 0.12),
          borderColor: AppColors.green,
          borderWidth: _selectedBorder,
          textColor: AppColors.green,
        );
      case MaintenancePriority.medium:
        return PriorityChipStyle(
          background: AppColors.accent.withValues(alpha: 0.12),
          borderColor: AppColors.accent,
          borderWidth: _selectedBorder,
          textColor: AppColors.accent,
        );
      case MaintenancePriority.high:
        return PriorityChipStyle(
          background: AppColors.red.withValues(alpha: 0.12),
          borderColor: AppColors.red,
          borderWidth: _selectedBorder,
          textColor: AppColors.red,
        );
    }
  }
}
