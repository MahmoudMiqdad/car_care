import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_ratings/presentation/widgets/car_washer_ratings_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// CW-CLEAN dead-code candidate: no Route points to this page anymore as
/// of CW3 — ratings are shown inline via [CarWasherRatingsSection] inside
/// the washer's own profile page and inside the customer's washer-details
/// page instead. Kept only so the page still compiles/exists pending a
/// dedicated cleanup batch; its body now defers to the same shared widget
/// rather than duplicating the ratings UI.
class CarWasherRatingsPage extends StatelessWidget {
  const CarWasherRatingsPage({super.key, required this.profile});
  final WasherProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: 'التقييمات',
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.pop(),
        ),
        body: ImageBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: CarWasherRatingsSection(carWasherId: profile.id),
          ),
        ),
      ),
    );
  }
}
