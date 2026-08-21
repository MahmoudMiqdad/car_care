import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/selection/select_trigger_field.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_illustration.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_location_hint.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_problem_field.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSosBody extends StatelessWidget {
  const CreateSosBody({
    super.key,
    required this.descriptionController,
    required this.vehicleValue,
    required this.provinceValue,
    required this.onPickVehicle,
    required this.onPickProvince,
    required this.onSubmit,
    this.isLoading = false,
  });

  final TextEditingController descriptionController;
  final String vehicleValue;
  final String provinceValue;
  final VoidCallback onPickVehicle;
  final VoidCallback onPickProvince;
  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CreateSosIllustration(),
            SelectTriggerField(
              leading: Icon(
                Icons.directions_car_outlined,
                color: AppColors.primary,
                size: 26.sp,
              ),
              label: l10n.createSosChooseVehicle,
              value: vehicleValue.isEmpty ? null : vehicleValue,
              placeholderAlpha: 0.45,
              labelValueGap: 0,
              onTap: isLoading ? () {} : onPickVehicle,
            ),
            SizedBox(height: 8.h),
            SelectTriggerField(
              leading: Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 26.sp,
              ),
              label: l10n.createSosChooseProvince,
              value: provinceValue.isEmpty ? null : provinceValue,
              placeholderAlpha: 0.45,
              labelValueGap: 0,
              onTap: isLoading ? () {} : onPickProvince,
            ),
            CreateSosLocationHint(text: l10n.createSosLocationAutoHint),
            SizedBox(height: 8.h),
            CreateSosProblemField(
              title: l10n.createSosProblemDescription,
              controller: descriptionController,
              hint: l10n.createSosSampleProblemText,
            ),
            SizedBox(height: 30.h),
            AppButton(
              text: isLoading
                  ? l10n.sosProcessingInProgress
                  : l10n.createSosSendRequest,
              onPressed: isLoading ? null : onSubmit,
              backgroundColor: isLoading
                  ? AppColors.accent.withValues(alpha: 0.6)
                  : AppColors.accent,
              height: 52.h,
              borderRadius: 14.r,
            ),
          ],
        ),
      ),
    );
  }
}
