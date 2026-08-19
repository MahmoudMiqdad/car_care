import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/domain/entities/washer_profile_entity.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_state.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_actions_row.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_avatar_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_labeled_field.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_services_section.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/edit_profile_page/edit_profile_washer_work_hours_row.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileWasherLoadedForm extends StatefulWidget {
  const EditProfileWasherLoadedForm({super.key, required this.profile});

  final WasherProfileEntity profile;

  @override
  State<EditProfileWasherLoadedForm> createState() =>
      _EditProfileWasherLoadedFormState();
}

class _EditProfileWasherLoadedFormState
    extends State<EditProfileWasherLoadedForm> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _workStart;
  late final TextEditingController _workEnd;
  late final TextEditingController _description;
  late final TextEditingController _basicPrice;
  late final TextEditingController _vipPrice;
  late final TextEditingController _premiumPrice;

  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _logoUrl = p.logoUrl;
    _name = TextEditingController(text: p.shopName);
    _phone = TextEditingController(text: p.phone);
    _address = TextEditingController(text: p.address);
    _description = TextEditingController(text: p.description);
    _basicPrice = TextEditingController(
      text: _priceStr(p.servicePrices, 'basic'),
    );
    _vipPrice = TextEditingController(text: _priceStr(p.servicePrices, 'vip'));
    _premiumPrice = TextEditingController(
      text: _priceStr(p.servicePrices, 'premium'),
    );
    _workStart = TextEditingController(text: _extractStart(p.workingHours));
    _workEnd = TextEditingController(text: _extractEnd(p.workingHours));
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _workStart.dispose();
    _workEnd.dispose();
    _description.dispose();
    _basicPrice.dispose();
    _vipPrice.dispose();
    _premiumPrice.dispose();
    super.dispose();
  }

  static String _priceStr(Map<String, int> prices, String key) =>
      (prices[key] ?? 0).toString();

  static String _extractStart(Map<String, String> hours) {
    if (hours.isEmpty) return '';
    final parts = hours.values.first.split('-');
    return parts.isNotEmpty ? parts.first.trim() : '';
  }

  static String _extractEnd(Map<String, String> hours) {
    if (hours.isEmpty) return '';
    final parts = hours.values.first.split('-');
    return parts.length > 1 ? parts[1].trim() : '';
  }

  Map<String, int> _buildPrices() {
    int p(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
    return {
      'basic': p(_basicPrice),
      'vip': p(_vipPrice),
      'premium': p(_premiumPrice),
    };
  }

  Map<String, String> _buildWorkingHours() {
    final start = _workStart.text.trim();
    final end = _workEnd.text.trim();
    final range = (start.isEmpty || end.isEmpty) ? '' : '$start-$end';

    final original = widget.profile.workingHours;
    if (original.isNotEmpty) {
      final updated = Map<String, String>.from(original);
      updated[original.keys.first] = range;
      return updated;
    }
    return {'sat': range, 'sun': range};
  }

  Future<void> _pickAndUploadLogo() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    context.read<ProfileWasherCubit>().uploadLogo(file.path);
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      AppSnackBar.error(context, 'يرجى إدخال اسم المغسلة');
      return;
    }

    context.read<ProfileWasherCubit>().saveProfile(
      shopName: _name.text.trim(),
      phone: _phone.text.trim(),
      city: widget.profile.city,
      address: _address.text.trim(),
      description: _description.text.trim(),
      services: List<String>.from(widget.profile.services),
      servicePrices: _buildPrices(),
      workingHours: _buildWorkingHours(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving =
        context.watch<ProfileWasherCubit>().state is ProfileWasherSaving;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EditProfileWasherAvatarSection(
                networkImageUrl: _logoUrl,
                onAddPhotoTap: isSaving ? null : _pickAndUploadLogo,
              ),
              SizedBox(height: 8.h),

              EditProfileWasherLabeledField(
                label: l10n.profileWasherFieldWasherName,
                hint: l10n.profileWasherHintWasherName,
                controller: _name,
                leadingIcon: Icon(
                  Icons.short_text_rounded,
                  color: AppColors.carWashTeal,
                  size: 26.sp,
                ),
              ),
              SizedBox(height: 8.h),

              EditProfileWasherLabeledField(
                label: l10n.profileWasherFieldPhone,
                hint: l10n.profileWasherHintPhone,
                controller: _phone,
                keyboardType: TextInputType.phone,
                leadingIcon: Icon(
                  Icons.phone_outlined,
                  color: AppColors.carWashTeal,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 8.h),

              EditProfileWasherLabeledField(
                label: l10n.profileWasherFieldAddress,
                hint: l10n.profileWasherHintAddress,
                controller: _address,
                leadingIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.carWashTeal,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 8.h),

              EditProfileWasherWorkHoursRow(
                startLabel: l10n.profileWasherFieldWorkStart,
                startHint: l10n.profileWasherHintWorkStart,
                endLabel: l10n.profileWasherFieldWorkEnd,
                endHint: l10n.profileWasherHintWorkEnd,
                startController: _workStart,
                endController: _workEnd,
              ),
              SizedBox(height: 10.h),

              EditProfileWasherServicesSection(
                sectionTitle: l10n.profileWasherChooseServicesTitle,
                descriptionLabel: l10n.profileWasherFieldDescription,
                descriptionHint: l10n.profileWasherHintDescription,
                basicTitle: l10n.profileWasherTierBasic,
                vipTitle: l10n.profileWasherTierVip,
                premiumTitle: l10n.profileWasherTierPremium,
                priceLabel: l10n.profileWasherFieldPrice,
                priceHint: l10n.profileWasherHintPrice,
                descriptionController: _description,
                basicPriceController: _basicPrice,
                vipPriceController: _vipPrice,
                premiumPriceController: _premiumPrice,
              ),
              SizedBox(height: 24.h),

              EditProfileWasherActionsRow(
                saveLabel: l10n.profileWasherSaveChanges,
                cancelLabel: l10n.cancel,
                onSave: isSaving ? null : _save,
                onCancel: isSaving ? null : () => context.pop(),
              ),
            ],
          ),
        ),

        if (isSaving)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
