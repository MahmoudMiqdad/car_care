import 'package:flutter/material.dart';

import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/widgets/car_washer_ratings_section.dart';

class WasherDetailsReviewsSection extends StatelessWidget {
  const WasherDetailsReviewsSection({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    return CarWasherRatingsSection(carWasherId: washer.id);
  }
}
