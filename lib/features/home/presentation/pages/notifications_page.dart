import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return ImageBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            children: [
             
              SizedBox(height: 8.h),
                EmptyStateWidget(),
               
            ],
          ),
        ),
      ),
    );
  }
}
