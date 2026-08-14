import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One colored slice of a [StatsSegmentedBar], sized proportionally to
/// [value] out of the sum of all segments' values.
class StatsSegment {
  const StatsSegment({required this.value, required this.color});

  final int value;
  final Color color;
}

/// A horizontal segmented bar built purely from real numeric values — no
/// percentages are computed or shown, it only encodes proportion visually.
/// Safe against a zero/empty total: renders a flat neutral bar instead of
/// dividing by zero or producing NaN.
class StatsSegmentedBar extends StatelessWidget {
  const StatsSegmentedBar({
    super.key,
    required this.segments,
    this.height = 10,
    this.emptyColor = const Color(0xFFE7E7E7),
  });

  final List<StatsSegment> segments;
  final double height;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);
    final radius = BorderRadius.circular((height / 2).r);

    if (total <= 0) {
      return ClipRRect(
        borderRadius: radius,
        child: Container(height: height.h, color: emptyColor),
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
