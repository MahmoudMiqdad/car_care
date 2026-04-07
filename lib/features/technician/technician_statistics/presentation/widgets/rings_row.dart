import 'package:car_care/features/technician/technician_statistics/presentation/widgets/ring_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RingsRow extends StatelessWidget {
  const RingsRow({
    super.key,
    required this.jobsCompleted,
    required this.jobsTotal,
    required this.quotationsAccepted,
    required this.quotationsTotal,
  });

  final int jobsCompleted;
  final int jobsTotal;
  final int quotationsAccepted;
  final int quotationsTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RingCard(
            title: 'الأعمال',
            mainValue: jobsTotal,
            subLabel: 'المكتملة',
            subValue: jobsCompleted,
            progress: jobsTotal == 0 ? 0 : jobsCompleted / jobsTotal,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RingCard(
            title: 'العروض',
            mainValue: quotationsTotal,
            subLabel: 'المقبولة',
            subValue: quotationsAccepted,
            progress: quotationsTotal == 0 ? 0 : quotationsAccepted / quotationsTotal,
          ),
        ),
      ],
    );
  }
}