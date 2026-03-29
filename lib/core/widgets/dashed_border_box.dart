import 'package:car_care/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashedBorderBox extends StatelessWidget {
  const DashedBorderBox({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius,
    this.strokeWidth = AppConstants.maintenanceRequestDashedStrokeWidth,
  });

  final Widget child;
  final Color color;
  final double? borderRadius;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final r = borderRadius ?? AppConstants.maintenanceRequestCardRadius.r;
    return CustomPaint(
      painter: DashedRectPainter(
        color: color,
        borderRadius: r,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class DashedRectPainter extends CustomPainter {
  DashedRectPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;

  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final path = Path()..addRRect(r);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final end = (d + _dash).clamp(0, m.length).toDouble();
        final extract = m.extractPath(d, end);
        canvas.drawPath(extract, paint);
        d += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.strokeWidth != strokeWidth;
}
