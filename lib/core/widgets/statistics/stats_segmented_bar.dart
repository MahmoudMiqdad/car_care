import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsSegment {
  const StatsSegment({required this.value, required this.color});

  final int value;
  final Color color;
}

class StatsSegmentedBar extends StatelessWidget {
  const StatsSegmentedBar({
    super.key,
    required this.segments,
    this.height = 10,
    this.emptyColor,
  });

  final List<StatsSegment> segments;
  final double height;
  final Color? emptyColor;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);
    final radius = BorderRadius.circular((height / 2).r);
    final effectiveEmptyColor =
        emptyColor ?? context.colorScheme.surfaceContainerHighest;

    if (total <= 0) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(height: height.h, color: effectiveEmptyColor),
      );
    }

    final positive = segments.where((s) => s.value > 0).toList();

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height.h,
        child: Row(
          children: [
            for (final segment in positive)
              Expanded(
                flex: segment.value,
                child: Container(color: segment.color),
              ),
          ],
        ),
      ),
    );
  }
}
