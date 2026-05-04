import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileWasherAvatarSection extends StatelessWidget {
  const EditProfileWasherAvatarSection({
    super.key,
    this.onAddPhotoTap,
    this.networkImageUrl,
  });

  final VoidCallback? onAddPhotoTap;
  final String? networkImageUrl;

  static const double _avatarDiameter = 132;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _avatarDiameter.r,
        height: _avatarDiameter.r,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AppCircleAvatar(
              diameter: _avatarDiameter,
              networkImageUrl: networkImageUrl,
              placeholderAssetPath: AppAssets.washersPatternBackground,
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              child: Material(
                color: AppColors.carWashTeal,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onAddPhotoTap,
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child: Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
