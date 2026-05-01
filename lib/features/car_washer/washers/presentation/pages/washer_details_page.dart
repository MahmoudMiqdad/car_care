import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washer_details/washer_details_view.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WasherDetailsPage extends StatelessWidget {
  const WasherDetailsPage({super.key, required this.washer});

  final WasherEntity washer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.washerDetailsTitle,
        showBackButton: true,
        onBackTapped: () => context.pop(),
      ),
      body: ImageBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
          child: WasherDetails(washer: washer),
        ),
      ),
    );
  }
}