import 'dart:io';

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician/technician_profile/domain/entities/technician_profile_entity.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_certificate_picker.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_location_card.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_form_fields.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class TechnicianProfileEditBodyContent extends StatefulWidget {
  final TechnicianDataEntity? initialData;

  const TechnicianProfileEditBodyContent({super.key, this.initialData});

  @override
  State<TechnicianProfileEditBodyContent> createState() =>
      _TechnicianProfileEditBodyContentState();
}

class _TechnicianProfileEditBodyContentState
    extends State<TechnicianProfileEditBodyContent> {
  late final TextEditingController _specializationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _hourlyRateController;

  List<XFile> _certificationImages = [];

  bool _isSubmittingUpdate = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _specializationController = TextEditingController(
      text: d?.specialization ?? '',
    );
    _experienceController = TextEditingController(
      text: d?.experienceYears?.toString() ?? '',
    );
    _phoneController = TextEditingController(text: d?.phone ?? '');
    _cityController = TextEditingController(text: d?.city ?? '');
    _hourlyRateController = TextEditingController(
      text: d?.hourlyRate?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _specializationController.dispose();
    _experienceController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _submit() {
    final params = <String, dynamic>{
      "specialization": _specializationController.text.trim(),
      "experience_years": _experienceController.text.trim(),
      "phone": _phoneController.text.trim(),
      "city": _cityController.text.trim(),
      "hourly_rate": _hourlyRateController.text.trim(),
    };

    for (int i = 0; i < _certificationImages.length; i++) {
      params["certifications[$i]"] = File(_certificationImages[i].path).path;
    }

    _isSubmittingUpdate = true;
    context.read<TechnicianProfileCubit>().updateTechnicianProfile(params);
  }
@override
Widget build(BuildContext context) {
  final l10n = context.l10n;

  return BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
    listener: (context, state) {
      if (state is TechnicianProfileLoaded && _isSubmittingUpdate) {
        _isSubmittingUpdate = false;
        context.pop(true);
      }
      if (state is TechnicianProfileError && _isSubmittingUpdate) {
        _isSubmittingUpdate = false;
        AppSnackBar.error(context, state.message);
      }
    },
    builder: (context, state) {
      final isLoading = state is TechnicianProfileLoading;

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TechnicianProfileFormFields(
                    phoneController: _phoneController,
                    cityController: _cityController,
                    specializationController: _specializationController,
                    experienceController: _experienceController,
                    hourlyRateController: _hourlyRateController,
                  ),
                  SizedBox(height: 14.h),
                  LocationUpdateCard(
                    initialDescription: l10n.updateWorkshopLocationDescription,
                    initialButtonLabel: l10n.changeLocationButton,
                  ),
                  SizedBox(height: 14.h),
                  TechnicianProfileSection(
                    title: l10n.certificationsSectionTitle,
                    icon: Icons.workspace_premium_outlined,
                    color: AppColors.primary,
                    trailing: Text(
                      l10n.maxThreeImagesHint,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.addNewCertificationsHint,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TechnicianCertificatePicker(
                          images: _certificationImages,
                          onImagesChanged: (updated) => setState(
                            () => _certificationImages = updated,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              child: SizedBox(
                height: AppConstants.buttonHeight.h,
                child: AppButton(
                  text: isLoading ? l10n.updatingProgress : l10n.saveChangesButtonLabel,
                  borderRadius: 20.r,
                  onPressed: isLoading ? null : _submit,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}}
