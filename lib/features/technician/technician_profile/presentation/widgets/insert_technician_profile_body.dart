import 'dart:io';

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_certificate_picker.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_location_card.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_form_fields.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_profile_section.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class InsertTechnicianProfileBody extends StatefulWidget {
  const InsertTechnicianProfileBody({super.key});

  @override
  State<InsertTechnicianProfileBody> createState() =>
      _TechnicianProfileBodyState();
}

class _TechnicianProfileBodyState extends State<InsertTechnicianProfileBody> {
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();

  List<XFile> _certificationImages = [];

  // Picked locally during onboarding — sent with the profile save request,
  // never through the protected /technician/location endpoint.
  LatLng? _pickedLocation;

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
      if (_pickedLocation != null) ...{
        "latitude": _pickedLocation!.latitude.toString(),
        "longitude": _pickedLocation!.longitude.toString(),
      },
    };

    for (int i = 0; i < _certificationImages.length; i++) {
      params["certifications[$i]"] = File(_certificationImages[i].path).path;
    }

    context.read<TechnicianProfileCubit>().insertTechnicianProfile(params);
  }

  /// After the profile is created the backend assigns the technician role.
  /// Refresh /auth/me and stored roles so More shows it immediately, then
  /// return to More (the technician entries are status-gated from there).
  Future<void> _refreshRolesAndExit() async {
    try {
      final model = await getIt<ProfileRemoteDataSource>().showprofile();
      final roles = model.data?.parsedRoles ?? const <String>[];
      if (roles.isNotEmpty) {
        await getIt<SecureStorage>().setRoles(roles);
      }
    } catch (_) {
      // Roles will still refresh next time More opens.
    }
    if (mounted) context.go(Routes.more);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
      listener: (context, state) {
        if (state is TechnicianProfileLoaded) {
          AppSnackBar.success(context, 'تم إرسال طلب الانضمام كفني بنجاح');
          _refreshRolesAndExit();
        }
        if (state is TechnicianProfileError) {
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
                      localOnly: true,
                      onLocationPicked: (picked) =>
                          setState(() => _pickedLocation = picked),
                    ),
                    SizedBox(height: 14.h),

                    TechnicianProfileSection(
                      title: 'الشهادات',
                      icon: Icons.workspace_premium_outlined,
                      color: AppColors.primary,
                      trailing: Text(
                        'حد أقصى 3 صور',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      child: TechnicianCertificatePicker(
                        images: _certificationImages,
                        onImagesChanged: (updated) =>
                            setState(() => _certificationImages = updated),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── زر الإضافة (فوق الشريط الآمن دائمًا) ────────────────────
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                child: SizedBox(
                  height: AppConstants.buttonHeight.h,
                  child: AppButton(
                    text: isLoading ? 'جارٍ الحفظ...' : 'إضافة فني',
                    backgroundColor: AppColors.orange,
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
  }
}
