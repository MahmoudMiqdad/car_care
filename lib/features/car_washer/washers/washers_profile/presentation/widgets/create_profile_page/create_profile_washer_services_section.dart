import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_headline.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_services_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Known default service chips. Purely a presentation convenience over the
/// existing free-text `servicesController` — these strings already exist as
/// the controller's seeded default text (see `_CreateProfileWasherViewState`
/// in create_profile_washer_page.dart) and are NOT new backend values.
const List<String> _kKnownServiceChips = ['غسيل عادي', 'غسيل ممتاز', 'تلميع'];

class CreateProfileWasherServicesSection extends StatefulWidget {
  const CreateProfileWasherServicesSection({
    super.key,
    required this.servicesLabel,
    required this.servicesHint,
    required this.sectionTitle,
    required this.descriptionLabel,
    required this.descriptionHint,
    required this.basicTitle,
    required this.vipTitle,
    required this.premiumTitle,
    required this.priceLabel,
    required this.priceHint,
    this.servicesController,
    this.descriptionController,
    this.basicPriceController,
    this.vipPriceController,
    this.premiumPriceController,
  });

  final String servicesLabel;
  final String servicesHint;
  final String sectionTitle;
  final String descriptionLabel;
  final String descriptionHint;
  final String basicTitle;
  final String vipTitle;
  final String premiumTitle;
  final String priceLabel;
  final String priceHint;
  final TextEditingController? servicesController;
  final TextEditingController? descriptionController;
  final TextEditingController? basicPriceController;
  final TextEditingController? vipPriceController;
  final TextEditingController? premiumPriceController;

  @override
  State<CreateProfileWasherServicesSection> createState() =>
      _CreateProfileWasherServicesSectionState();
}

class _CreateProfileWasherServicesSectionState
    extends State<CreateProfileWasherServicesSection> {
  late final TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    final extras = _currentList()
        .where((s) => !_kKnownServiceChips.contains(s))
        .toList();
    _otherController = TextEditingController(text: extras.join(', '));
    _otherController.addListener(_onOtherChanged);
  }

  @override
  void dispose() {
    _otherController.removeListener(_onOtherChanged);
    _otherController.dispose();
    super.dispose();
  }

  // Same parsing rule as _parseServices() in create_profile_washer_page.dart
  // — comma-split, trim, drop empties. Kept in sync deliberately so the
  // chips/extras UI never diverges from what actually gets submitted.
  List<String> _currentList() => (widget.servicesController?.text ?? '')
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  void _onOtherChanged() {
    final selectedKnown = _currentList()
        .where(_kKnownServiceChips.contains)
        .toList();
    final extras = _otherController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    final merged = [...selectedKnown, ...extras].join(', ');
    final controller = widget.servicesController;
    if (controller != null && controller.text != merged) {
      controller.text = merged;
    }
  }

  void _toggleChip(String label) {
    final controller = widget.servicesController;
    if (controller == null) return;
    final list = _currentList();
    if (list.contains(label)) {
      list.remove(label);
    } else {
      list.add(label);
    }
    controller.text = list.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(
          widget.servicesLabel,
          color: AppColors.black,
          fontSize: 17.sp,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 10.h),
        if (widget.servicesController != null)
          ListenableBuilder(
            listenable: widget.servicesController!,
            builder: (context, _) {
              final selected = _currentList();
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _kKnownServiceChips
                    .map(
                      (label) => _ServiceChip(
                        label: label,
                        isSelected: selected.contains(label),
                        onTap: () => _toggleChip(label),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        SizedBox(height: 10.h),
        EditProfileWasherLabeledField(
          label: 'خدمات أخرى',
          hint: widget.servicesHint,
          controller: _otherController,
          leadingIcon: Icon(
            Icons.add_circle_outline,
            color: AppColors.carWashTeal,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 14.h),
        EditProfileWasherServicesSection(
          sectionTitle: widget.sectionTitle,
          descriptionLabel: widget.descriptionLabel,
          descriptionHint: widget.descriptionHint,
          basicTitle: widget.basicTitle,
          vipTitle: widget.vipTitle,
          premiumTitle: widget.premiumTitle,
          priceLabel: widget.priceLabel,
          priceHint: widget.priceHint,
          descriptionController: widget.descriptionController,
          basicPriceController: widget.basicPriceController,
          vipPriceController: widget.vipPriceController,
          premiumPriceController: widget.premiumPriceController,
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.carWashTeal : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.carWashTeal
                  : AppColors.carWashTeal.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
