import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatelessWidget {

  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(context.l10n.providerProfileAvailabilityTitle),
      ),
    );
  }

}
