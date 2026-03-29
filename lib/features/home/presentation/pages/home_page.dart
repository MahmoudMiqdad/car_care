import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/features/home/presentation/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.artboardBackground,
          fit: BoxFit.cover,
        ),
        const HomeBody(),
      ],
    );
  }
}
