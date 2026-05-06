import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/ratings/presentation/widgets/ratings_page/ratings_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedStars = 3;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(title: strings.rateService, showBackButton: true),
        body: ImageBackground(
          child: RatingsBody(
            selectedStars: _selectedStars,
            commentController: _commentController,
            onStarsChanged: (value) {
              setState(() {
                _selectedStars = value;
              });
            },
            onSubmit: () {},
          ),
        ),
      ),
    );
  }
}
