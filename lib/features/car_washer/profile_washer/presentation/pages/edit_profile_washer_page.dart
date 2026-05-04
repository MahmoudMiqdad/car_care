import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/models/profile_washer_ui_model.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_loaded_form.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileWasherPage extends StatelessWidget {
  const EditProfileWasherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preview = ProfileWasherUiModel.previewForLocale(Localizations.localeOf(context));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: l10n.profileWasherEditPageTitle,
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.profile_washer);
            }
          },
        ),
        body: ImageBackground(
          child: EditProfileWasherLoadedForm(profile: preview),
        ),
      ),
    );
  }
}
