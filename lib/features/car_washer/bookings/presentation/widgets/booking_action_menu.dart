import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n.dart';

class BookingActionMenu extends StatefulWidget {
  const BookingActionMenu({this.showAsOpen = false, super.key});

  final bool showAsOpen;

  @override
  State<BookingActionMenu> createState() => _BookingActionMenuState();
}

class _BookingActionMenuState extends State<BookingActionMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookingCardAction>(
     color: Colors.white, 
      tooltip: '',
      offset: Offset(6.w, 40.h),
      icon: Icon(
        Icons.more_vert,
        size: 24.sp,
        color: AppColors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: const BorderSide(color: AppColors.primary, width: 1),
      ),
      itemBuilder: (_) {
        return [
          PopupMenuItem<BookingCardAction>(
            value: BookingCardAction.showDetails,
            child: BookingMenuItemRow(
              label: context.l10n.bookingsMenuShowDetails,
              icon: Icons.description_outlined,
            ),
          ),
          const PopupMenuDivider(height: 0),
          PopupMenuItem<BookingCardAction>(
            value: BookingCardAction.cancelBooking,
            child: BookingMenuItemRow(
              label: context.l10n.bookingsMenuCancelBooking,
              icon: Icons.close,
            ),
          ),
          const PopupMenuDivider(height: 0),
          PopupMenuItem<BookingCardAction>(
            value: BookingCardAction.rateService,
            child: BookingMenuItemRow(
              label: context.l10n.bookingsMenuRateService,
              icon: Icons.star,
            ),
          ),
        ];
      },
      onSelected: (_) {},
    );
  }
}

enum BookingCardAction { showDetails, cancelBooking, rateService }

class BookingMenuIcon extends StatelessWidget {
  const BookingMenuIcon({required this.showAsOpen, super.key});

  final bool showAsOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26.h,
      width: 26.h,
      decoration: BoxDecoration(
        color: AppColors.lightScaffold,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Icon(
        showAsOpen ? Icons.more_vert : Icons.more_horiz,
        size: 18.sp,
        color: AppColors.black,
      ),
    );
  }
}

class BookingMenuItemRow extends StatelessWidget {
  const BookingMenuItemRow({
    required this.label,
    required this.icon,
    super.key,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.w,
      child: Row(
        children: [
          Icon(icon, size: 17.sp, color: AppColors.primary),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
