
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/user_profile/presentation/cubit/update_profile_cubit/update_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/update_profile_cubit/update_profile_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfileSetupForm extends StatefulWidget {
  ProfileSetupForm({super.key, this.Image});
  final String? Image;
  @override
  State<ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final params = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
    };

    context.read<UpdateProfileCubit>().updateProfile(params);
  }

  @override
  Widget build(BuildContext context) {
     final strings = context.l10n;
    return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(strings.profileUpdated),
            ),
          );
        }
        if (state is UpdateProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginTextField(
              controller: _nameController,
              hintText: strings.fullName,
              icon: Icons.person,
            ),
            SizedBox(height: 16.h),
            LoginTextField(
              controller: _phoneController,
              hintText: strings.phoneNumber,
              icon: Icons.call,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.h),
            LoginTextField(
              controller: _emailController,
              hintText: strings.email,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 50.h,
              child: AppButton(
                onPressed: isLoading ? null : () => _submit(context),
                text:strings.saveandfollow,
                backgroundColor: AppColors.orange,
                textColor: Colors.white,
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(child: AppLoadingWidget()),
              ),
          ],
        );
      },
    );
  }
}