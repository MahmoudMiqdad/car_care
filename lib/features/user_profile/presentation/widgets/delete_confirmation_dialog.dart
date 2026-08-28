import 'dart:ui';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
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
  const DeleteProfileDialog({super.key});

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
            AppSnackBar.success(context, strings.accountDeletedSuccessMessage);
            final navigator = Navigator.of(context, rootNavigator: true);
            final router = GoRouter.of(context);
            Future.delayed(const Duration(milliseconds: 1300), () {
              navigator.pop();
              router.go(Routes.signup);
            });
          } else if (state is DeleteProfileError) {
            AppSnackBar.error(context, localizeErrorMessage(context, state.message));
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteProfileLoading;
          final colorScheme = context.colorScheme;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              backgroundColor: colorScheme.surfaceContainer,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: colorScheme.error,
                          size: 45.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        strings.deleteProfile,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        strings.confirmDeleteProfileMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
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
                                  color: colorScheme.onSurfaceVariant,
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
                                backgroundColor: colorScheme.error,
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
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              colorScheme.onError,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      strings.confirmDeleteProfileTitle,
                                      style: TextStyle(
                                        color: colorScheme.onError,
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
