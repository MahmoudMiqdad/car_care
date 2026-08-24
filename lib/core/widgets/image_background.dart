import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({
    super.key,
    required this.child,
    this.backgroundAsset = AppAssets.artboardBackground,
  });

  final Widget child;
  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedAsset = isDark ? AppAssets.darkBackground : backgroundAsset;

    final pattern = Image.asset(
      resolvedAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, _, _) =>
          ColoredBox(color: colorScheme.surfaceContainerHighest),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: colorScheme.surface),
        pattern,
        child,
      ],
    );
  }
}
