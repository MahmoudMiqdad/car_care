import 'package:car_care/core/widgets/statistics/ring_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsRingsRow extends StatelessWidget {
  const StatsRingsRow({super.key, required this.cards});

  final List<RingCardData> cards;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();

    if (cards.length == 1) {
      return RingCard(data: cards.first);
    }

    
    return Row(
      children: [
        Expanded(child: RingCard(data: cards[0])),
        SizedBox(width: 7.w),
        Expanded(child: RingCard(data: cards[1])),
      ],
    );
  }
}
