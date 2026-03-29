import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum MaintenancePriority {
  low,
  medium,
  urgent,
}

extension MaintenancePriorityArLabel on MaintenancePriority {
  String get labelAr {
    switch (this) {
      case MaintenancePriority.low: return 'منخفضة';
      case MaintenancePriority.medium: return 'متوسطة';
      case MaintenancePriority.urgent: return 'طارئة';
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
    required MaintenancePriority value,
    required MaintenancePriority selected,
  }) {
    final isSelected = value == selected;

    if (!isSelected) {
      return const PriorityChipStyle(
        background: AppColors.white,
        borderColor: Color(0xFFE0E0E0),
        borderWidth: _defaultBorder,
        textColor: AppColors.black,
      );
    }

    switch (value) {
      case MaintenancePriority.low:
        return const PriorityChipStyle(
          background: Color(0xFFE8F5E9),
          borderColor: Colors.green,
          borderWidth: _selectedBorder,
          textColor: Colors.green,
        );
      case MaintenancePriority.medium:
        return const PriorityChipStyle(
          background: Color(0xFFFFF3E0),
          borderColor: AppColors.orange, 
          borderWidth: _selectedBorder,
          textColor: AppColors.orange,
        );
      case MaintenancePriority.urgent:
        return const PriorityChipStyle(
          background: Color(0xFFFFEBEE),
          borderColor: AppColors.error,
          borderWidth: _selectedBorder,
          textColor: AppColors.error,
        );
    }
  }
}