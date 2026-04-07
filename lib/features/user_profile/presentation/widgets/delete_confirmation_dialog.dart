import 'dart:ui';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:car_care/features/user_profile/presentation/cubit/delete_profile_cubit/delete_profile_cubit.dart';
import 'package:car_care/features/user_profile/presentation/cubit/delete_profile_cubit/delete_profile_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:car_care/core/routing/routes.dart';

class DeleteProfileDialog extends StatefulWidget {
  const DeleteProfileDialog({super.key,});

  @override
  State<DeleteProfileDialog> createState() => _DeleteProfileDialogState();
}

class _DeleteProfileDialogState extends State<DeleteProfileDialog> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocProvider(
      create: (_) => DeleteProfileCubit(getIt<IProfileRepository>()),
      child: BlocConsumer<DeleteProfileCubit, DeleteProfileState>(
        listener: (context, state) {
          if (state is DeleteProfileSuccess) {
        
            context.go(Routes.signup); 
          } else if (state is DeleteProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteProfileLoading;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1F1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: const Color(0xFFA12323),
                          size: 45.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        strings.deleteProfile,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        strings.confirmDeleteProfileMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      LoginTextField(
                        controller: _passwordController,
                        hintText: strings.enterPassword,
                        isPassword: true,
                        icon: Icons.lock_outline,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                strings.cancel,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context
                                          .read<DeleteProfileCubit>()
                                          .deleteProfile(
                                            _passwordController.text,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA12323),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 18.h,
                                      width: 18.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      strings.confirmDeleteProfileTitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}