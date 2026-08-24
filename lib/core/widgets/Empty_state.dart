import 'dart:math';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatefulWidget {
  const EmptyStateWidget({super.key});

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _wheelCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _roadCtrl;

  late Animation<double> _floatAnim;
  late Animation<double> _wheelAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _roadAnim;

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _wheelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _roadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _floatAnim = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _wheelAnim = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _wheelCtrl, curve: Curves.linear));

    _roadAnim = Tween<double>(
      begin: 0,
      end: 60,
    ).animate(CurvedAnimation(parent: _roadCtrl, curve: Curves.linear));

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _wheelCtrl.dispose();
    _roadCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _floatAnim,
                    _wheelAnim,
                    _roadAnim,
                  ]),
                  builder: (_, _) => CustomPaint(
                    painter: _CarPainter(
                      floatOffset: _floatAnim.value,
                      wheelAngle: _wheelAnim.value,
                      roadOffset: _roadAnim.value,
                      primaryColor: colorScheme.primary,
                      secondaryColor: colorScheme.secondary,
                      accentColor: colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.noData,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.noDataSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  final double floatOffset;
  final double wheelAngle;
  final double roadOffset;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  _CarPainter({
    required this.floatOffset,
    required this.wheelAngle,
    required this.roadOffset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final primary = primaryColor;
    final secondary = secondaryColor;
    final accent = accentColor;

    final roadPaint = Paint()..color = primary.withOpacity(0.10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * 0.82, w, h * 0.1),
        const Radius.circular(4),
      ),
      roadPaint,
    );

    final dashPaint = Paint()
      ..color = primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, h * 0.84, w, h * 0.05));
    for (double x = -60 + (roadOffset % 60); x < w + 60; x += 60) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, h * 0.845, 35, h * 0.03),
          const Radius.circular(2),
        ),
        dashPaint,
      );
    }
    canvas.restore();

    canvas.save();
    canvas.translate(0, floatOffset);

    final carY = h * 0.38;
    final carH = h * 0.32;
    final carX = w * 0.10;
    final carW = w * 0.80;

    final bodyPaint = Paint()..color = primary;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(carX, carY + carH * 0.35, carW, carH * 0.65),
        const Radius.circular(8),
      ),
      bodyPaint,
    );

    final roofPath = Path()
      ..moveTo(carX + carW * 0.22, carY + carH * 0.35)
      ..quadraticBezierTo(
        carX + carW * 0.32,
        carY,
        carX + carW * 0.44,
        carY - carH * 0.04,
      )
      ..lineTo(carX + carW * 0.68, carY - carH * 0.04)
      ..quadraticBezierTo(
        carX + carW * 0.78,
        carY,
        carX + carW * 0.88,
        carY + carH * 0.35,
      )
      ..close();
    canvas.drawPath(roofPath, bodyPaint);

    final windPath = Path()
      ..moveTo(carX + carW * 0.26, carY + carH * 0.33)
      ..quadraticBezierTo(
        carX + carW * 0.34,
        carY + carH * 0.06,
        carX + carW * 0.45,
        carY + carH * 0.02,
      )
      ..lineTo(carX + carW * 0.68, carY + carH * 0.02)
      ..quadraticBezierTo(
        carX + carW * 0.76,
        carY + carH * 0.06,
        carX + carW * 0.84,
        carY + carH * 0.33,
      )
      ..close();
    canvas.drawPath(windPath, Paint()..color = secondary.withOpacity(0.85));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          carX + carW * 0.04,
          carY + carH * 0.15,
          carW * 0.18,
          carH * 0.2,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = secondary.withOpacity(0.5),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          carX + carW * 0.88,
          carY + carH * 0.52,
          carW * 0.07,
          carH * 0.14,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = accent,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(carX, carY + carH * 0.52, carW * 0.06, carH * 0.14),
        const Radius.circular(3),
      ),
      Paint()..color = accent.withOpacity(0.7),
    );

    canvas.drawLine(
      Offset(carX + carW * 0.5, carY + carH * 0.37),
      Offset(carX + carW * 0.5, carY + carH),
      Paint()
        ..color = secondary.withOpacity(0.3)
        ..strokeWidth = 1.5,
    );

    _drawWheel(
      canvas,
      Offset(carX + carW * 0.24, carY + carH * 0.95),
      carH * 0.22,
    );
    _drawWheel(
      canvas,
      Offset(carX + carW * 0.76, carY + carH * 0.95),
      carH * 0.22,
    );

    final badgeCenter = Offset(w * 0.5, carY - carH * 0.18);
    canvas.drawCircle(
      badgeCenter,
      carH * 0.18,
      Paint()..color = accent.withOpacity(0.15),
    );
    final iconPainter = TextPainter(
      text: const TextSpan(text: '🔧', style: TextStyle(fontSize: 22)),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      badgeCenter - Offset(iconPainter.width / 2, iconPainter.height / 2),
    );

    canvas.restore();

    final t = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _drawDot(
      canvas,
      Offset(w * 0.85, h * 0.28),
      accent,
      (sin(t * 1.8) * 0.5 + 0.5),
    );
    _drawDot(
      canvas,
      Offset(w * 0.12, h * 0.40),
      primary,
      (sin(t * 1.8 + 2.0) * 0.5 + 0.5),
    );
    _drawDot(
      canvas,
      Offset(w * 0.90, h * 0.55),
      accent.withOpacity(0.7),
      (sin(t * 1.8 + 4.0) * 0.5 + 0.5),
    );
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF1a1a2e));
    canvas.drawCircle(center, radius * 0.55, Paint()..color = primaryColor);
    canvas.drawCircle(center, radius * 0.22, Paint()..color = secondaryColor);
    final spokePaint = Paint()
      ..color = secondaryColor.withOpacity(0.5)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 4; i++) {
      final angle = wheelAngle + i * pi / 2;
      canvas.drawLine(
        center + Offset(cos(angle) * radius * 0.22, sin(angle) * radius * 0.22),
        center + Offset(cos(angle) * radius * 0.5, sin(angle) * radius * 0.5),
        spokePaint,
      );
    }
  }

  void _drawDot(Canvas canvas, Offset center, Color color, double opacity) {
    canvas.drawCircle(
      center,
      6,
      Paint()..color = color.withOpacity(opacity.clamp(0.1, 1.0)),
    );
  }

  @override
  bool shouldRepaint(covariant _CarPainter old) =>
      old.floatOffset != floatOffset ||
      old.wheelAngle != wheelAngle ||
      old.roadOffset != roadOffset ||
      old.primaryColor != primaryColor ||
      old.secondaryColor != secondaryColor ||
      old.accentColor != accentColor;
}
