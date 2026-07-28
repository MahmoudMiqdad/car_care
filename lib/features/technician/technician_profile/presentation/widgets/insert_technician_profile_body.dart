import 'dart:io';

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/local_storage/secure_storage.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit/technician_profile_state.dart';
import 'package:car_care/features/technician/technician_profile/presentation/widgets/technician_location_card.dart';
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class InsertTechnicianProfileBody extends StatefulWidget {
  const InsertTechnicianProfileBody({super.key});

  @override
  State<InsertTechnicianProfileBody> createState() => _TechnicianProfileBodyState();
}

class _TechnicianProfileBodyState extends State<InsertTechnicianProfileBody> {
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();

  final List<XFile> _certificationImages = [];
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickCertificationImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;

    if (images.length + _certificationImages.length > 3) {
      // ignore: use_build_context_synchronously
      AppSnackBar.error(context, 'يمكنك اختيار 3 صور كحد أقصى');
      return;
    }

    setState(() => _certificationImages.addAll(images));
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
        // await getIt<SecureStorage>().setRoles(roles);
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

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),

              LoginTextField(
                controller: _specializationController,
                hintText: 'التخصص',
                iconPath: 'assets/images/icons8-work-50.png',
              ),
              SizedBox(height: 12.h),

              LoginTextField(
                controller: _experienceController,
                hintText: 'سنوات الخبرة',
                iconPath: 'assets/images/icons8-certificate-72.png',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),

              LoginTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                icon: IconsaxPlusLinear.call,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.h),

              LoginTextField(
                controller: _cityController,
                hintText: 'المدينة',
                iconPath: 'assets/images/icons8-location-50.png',
              ),
              SizedBox(height: 12.h),

              LoginTextField(
                controller: _hourlyRateController,
                hintText: 'الأجر بالساعة',
                iconPath: 'assets/images/icons8-money-64.png',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              SizedBox(height: 16.h),

              LocationUpdateCard(
                localOnly: true,
                onLocationPicked: (picked) =>
                    setState(() => _pickedLocation = picked),
              ),
              SizedBox(height: 20.h),

              Text(
                'الشهادات (حد أقصى 3 صور)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._certificationImages.map((image) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(image.path),
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _certificationImages.remove(image),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  if (_certificationImages.length < 3)
                    GestureDetector(
                      onTap: _pickCertificationImages,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.grey.shade500,
                              size: 24.r,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'إضافة',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24.h),

              // ─── زر الإضافة ───────────────────────────────────────────
              SizedBox(
                height: AppConstants.buttonHeight.h,
                child: AppButton(
                  text: isLoading ? 'جارٍ الحفظ...' : 'إضافة فني',
                  backgroundColor: AppColors.orange,
                  borderRadius: 20.r,
                  onPressed: isLoading ? null : _submit,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}