import 'package:car_care/features/car_washer/washers/domain/car_wash_listing.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_contact_row.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_header.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_location_card.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_reviews_section.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasherDetails extends StatelessWidget {
  const WasherDetails({super.key, required this.listing});

  final CarWashListing listing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        WasherDetailsHeader(listing: listing),
        SizedBox(height: 16.h),
        WasherDetailsContactRow(listing: listing),
        SizedBox(height: 8.h),
        WasherDetailsLocationCard(listing: listing),
        SizedBox(height: 8),
        WasherDetailsServicesSection(listing: listing),
        SizedBox(height: 8.h),
        WasherDetailsReviewsSection(listing: listing),
      ],
    );
  }
}
