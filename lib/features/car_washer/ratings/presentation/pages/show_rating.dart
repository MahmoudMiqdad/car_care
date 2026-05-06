// ignore_for_file: camel_case_types
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/show_ratings/show_rating_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class ShowRatingPage extends StatelessWidget {
  const ShowRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: strings.rateService,
          showBackButton: true,
        ),
        body: const ImageBackground(child: ShowRatingBody()),
      ),
    );
  }
}
