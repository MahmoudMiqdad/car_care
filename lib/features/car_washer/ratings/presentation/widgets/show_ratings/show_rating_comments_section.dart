import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowRatingCommentsSection extends StatelessWidget {
  const ShowRatingCommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final comments = [
      Comment(
        "شدن العلي ",
        "يا له من مغسل رائع",
      ),
      Comment(
        "أحمد محمد ",
        "يا له من خدمة مذهلة",
      ),
      Comment(
        "مايا محايري",
        "خدمة ممتازة",
      ),
      Comment(
        "سليمى علي",
        "خدمة غير مرضية",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          strings.showRatingUsersComments,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        ...comments.map((comment) => CommentTile(comment: comment)),
      ],
    );
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.primary, width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.3),
              image: const DecorationImage(
                image: AssetImage(AppAssets.reviewerProfilePicture100),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  comment.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextSecondary.withValues(alpha: .7),
                  ),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}

class Comment {
  const Comment(this.name, this.message);

  final String name;
  final String message;
}
