import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/user_profile/presentation/widgets/profile_setup/ProfileAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianProfileBody extends StatefulWidget {
  const TechnicianProfileBody({super.key});
  @override
  State<TechnicianProfileBody> createState() => _TechnicianProfileBodyState();
}

class _TechnicianProfileBodyState extends State<TechnicianProfileBody> {
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _certificatesController =
      TextEditingController();

  @override
  void dispose() {
    _specializationController.dispose();
    _experienceController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _hourlyRateController.dispose();
    _certificatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Center(child: ProfileAvatar(cameraBadgeColor: AppColors.orange)),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _specializationController,
            hintText: 'التخصص',
            iconPath: 'assets/images/icons8-work-50.png',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _experienceController,
            hintText: 'سنوات الخبرة',
            iconPath: 'assets/images/icons8-certificate-72.png',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _phoneController,
            hintText: 'رقم الهاتف',
            iconPath: 'assets/images/icons8-call-50.png',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _cityController,
            hintText: 'المدينة',
            iconPath: 'assets/images/icons8-location-50.png',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _hourlyRateController,
            hintText: 'الأجر بالساعة',
            iconPath: 'assets/images/icons8-money-64.png',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 10.h),
          LoginTextField(
            controller: _certificatesController,
            hintText: 'الشهادات',
            iconPath: 'assets/images/icons8-certificate-50.png',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: AppConstants.buttonHeight.h,
            child: AppButton(
              text: 'حفظ المركبة',
              backgroundColor: AppColors.orange,
              borderRadius: 20.r,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}