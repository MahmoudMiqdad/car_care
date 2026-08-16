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

  // Presentation-only flag: getTechnicianProfile() and
  // updateTechnicianProfile() both emit the same TechnicianProfileLoaded
  // type on this cubit, but this screen only ever calls
  // updateTechnicianProfile() — so a Loaded state reaching this listener is
  // always this screen's own update completing, never a GET. This flag
  // still guards that assumption explicitly rather than relying on it
  // implicitly, so a future call to getTechnicianProfile() on this same
  // cubit instance can't accidentally trigger an auto-pop.
  bool _isSubmittingUpdate = false;

  @override
  void initState() {
    super.initState();
    // ← تملى الحقول بالبيانات الموجودة تلقائياً
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
    return BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
      listener: (context, state) {
        // Only a Loaded/Error that followed THIS screen's own update
        // request counts as an update result — never a generic Loaded
        // (e.g. from a GET) mistaken for update success.
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

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
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

                      // لا نعرض إحداثيات محفوظة وهمية: استجابة الملف الفني
                      // لا تتضمّن lat/lng محفوظة أصلًا.
                      const LocationUpdateCard(
                        initialDescription:
                            'يمكنك تحديث موقع الورشة عند الحاجة',
                        initialButtonLabel: 'تغيير الموقع',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'يمكنك إضافة شهادات جديدة',
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.grey.shade500,
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

              // ─── زر الحفظ (فوق الشريط الآمن دائمًا) ────────────────────
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                  child: SizedBox(
                    height: AppConstants.buttonHeight.h,
                    child: AppButton(
                      text: isLoading ? 'جارٍ الحفظ...' : 'حفظ التعديلات',
                      backgroundColor: AppColors.orange,
                      borderRadius: 20.r,
                      onPressed: isLoading ? null : _submit,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
