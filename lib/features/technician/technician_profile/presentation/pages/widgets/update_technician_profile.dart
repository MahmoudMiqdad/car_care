import 'dart:io';

import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';

import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_cubit.dart';
import 'package:car_care/features/technician/technician_profile/presentation/cubit/technician_profile_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

class TechnicianProfileEditBodyContent extends StatefulWidget {
  const TechnicianProfileEditBodyContent({super.key});

  @override
  State<TechnicianProfileEditBodyContent> createState() =>
      _TechnicianProfileEditBodyState();
}

class _TechnicianProfileEditBodyState
    extends State<TechnicianProfileEditBodyContent> {
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();

  final List<XFile> _certificationImages = [];
  final ImagePicker _picker = ImagePicker();

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يمكنك اختيار 3 صور كحد أقصى'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _certificationImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocConsumer<TechnicianProfileCubit, TechnicianProfileState>(
      listener: (context, state) {
        if (state is TechnicianProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث الملف الشخصي بنجاح"),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is TechnicianProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
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

              /// التخصص
              LoginTextField(
                controller: _specializationController,
                hintText: 'التخصص',
                iconPath: 'assets/images/icons8-work-50.png',
              ),

              SizedBox(height: 10.h),

              /// الخبرة
              LoginTextField(
                controller: _experienceController,
                hintText: 'سنوات الخبرة',
                iconPath: 'assets/images/icons8-certificate-72.png',
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10.h),

              /// الهاتف
              LoginTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                icon: IconsaxPlusLinear.call,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 10.h),

           
              LoginTextField(
                controller: _cityController,
                hintText: 'المدينة',
                iconPath: 'assets/images/icons8-location-50.png',
              ),

              SizedBox(height: 10.h),

              LoginTextField(
                controller: _hourlyRateController,
                hintText: 'الأجر بالساعة',
                iconPath: 'assets/images/icons8-money-64.png',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'الشهادات (حد أقصى 3 صور)',
                style: TextStyle(fontSize: 14.sp),
              ),

              SizedBox(height: 10.h),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._certificationImages.map((image) {
                    return Stack(
                      children: [
                        Image.file(
                          File(image.path),
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _certificationImages.remove(image);
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.red),
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
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20.h),

              SizedBox(
                height: AppConstants.buttonHeight.h,
                child: AppButton(
                  text: isLoading ? 'جارٍ الحفظ...' : 'تحديث ',
                  backgroundColor: AppColors.orange,
                  borderRadius: 20.r,
                  onPressed: isLoading
                      ? null
                      : () {
                          final params = {
                            "specialization": _specializationController.text,
                            "experience_years": _experienceController.text,
                            "phone": _phoneController.text,
                            "city": _cityController.text,
                            "hourly_rate": _hourlyRateController.text,
                          };

                          for (
                            int i = 0;
                            i < _certificationImages.length;
                            i++
                          ) {
                            params["certifications[$i]"] = File(
                              _certificationImages[i].path,
                            ).path;
                          }

                          context
                              .read<TechnicianProfileCubit>()
                              .updateTechnicianProfile(params);
                        },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
