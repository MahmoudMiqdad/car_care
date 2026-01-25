import 'package:car_care/core/constants/app_assets.dart';
import 'package:flutter/material.dart';


class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.imagePath,
    this.opacity = .2,
    super.key,
  });

  final Widget child;
  final String? imagePath;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              imagePath ?? AppAssets.splashBackgroundImg,

              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}
