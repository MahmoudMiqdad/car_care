import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_contact_row.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_header.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_location_card.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_reviews_section.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetails extends StatelessWidget {
  const WasherDetails({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        WasherDetailsHeader(washer: washer),
        SizedBox(height: 12.h),
        WasherDetailsContactRow(washer: washer),
        SizedBox(height: 8.h),
        WasherDetailsLocationCard(washer: washer),
        SizedBox(height: 8.h),
        WasherDetailsServicesSection(washer: washer),
      ],
    );
  }
}