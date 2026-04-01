import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/arabic_formatting.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/photo_attachment_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/preferred_date_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/priority_selector.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/problem_description_field.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_action_buttons.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/vehicle_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final TextEditingController _problemController = TextEditingController();
  int _photoCount = 0;
  DateTime selectedDate = DateTime(2020, 10, 12);
  MaintenancePriority _priority = MaintenancePriority.medium;

  double get _cardR => AppConstants.maintenanceRequestCardRadius.r;

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: AppConstants.localeAr,
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: const CustomAppBar(
          title: 'Maintenance Request',
          showBackButton: true,
        ),
        bottomNavigationBar: HomeBottomNavBar(
          onItemSelected: (index) {
            if (index == 0) context.go(Routes.home);
          },
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.artboardBackground,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VehicleInfoSection(cardRadius: _cardR),
                  SizedBox(height: 20.h),
                  AppText.sectionTitle('تفاصيل الطلب'),
                  SizedBox(height: 5.h),
                  ProblemDescriptionField(
                    cardRadius: _cardR,
                    controller: _problemController,
                  ),
                  SizedBox(height: 12.h),
                  PhotoAttachmentSection(
                    cardRadius: _cardR,
                    photoCount: _photoCount,
                    onAddPhoto: () {
                      if (_photoCount < 3) setState(() => _photoCount++);
                    },
                  ),
                  SizedBox(height: 12.h),
                  PreferredDateSection(
                    cardRadius: _cardR,
                    formattedDate: ArabicFormatting.formatDateSlashedEastern(selectedDate),
                    onPickDate: _pickDate,
                  ),
                  SizedBox(height: 20.h),
                  PrioritySelector(
                    selected: _priority,
                    onChanged: (p) => setState(() => _priority = p),
                  ),
                  SizedBox(height: 24.h),
                  RequestsActionButtons(
                    cardRadius: _cardR,
                    onSubmit: () {},
                    onCancel: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
