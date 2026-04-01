import 'package:car_care/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.artboardBackground,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: Color(0xFFE8EEF2)),
        ),
        child,
      ],
    );
  }
}
