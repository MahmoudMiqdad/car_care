import 'package:car_care/features/car_washer/profile_washer/presentation/models/profile_washer_ui_model.dart';
import 'package:car_care/features/car_washer/profile_washer/presentation/widgets/edit_profile_page/edit_profile_washer_form_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileWasherLoadedForm extends StatefulWidget {
  const EditProfileWasherLoadedForm({
    super.key,
    required this.profile,
  });

  final ProfileWasherUiModel profile;

  @override
  State<EditProfileWasherLoadedForm> createState() =>
      _EditProfileWasherLoadedFormState();
}

class _EditProfileWasherLoadedFormState extends State<EditProfileWasherLoadedForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _workStartController;
  late final TextEditingController _workEndController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _basicPriceController;
  late final TextEditingController _vipPriceController;
  late final TextEditingController _premiumPriceController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _phoneController = TextEditingController(text: p.phone);
    _addressController = TextEditingController(text: p.address);
    _workStartController = TextEditingController(text: p.workStart);
    _workEndController = TextEditingController(text: p.workEnd);
    _descriptionController = TextEditingController(text: p.description);
    _basicPriceController = TextEditingController(text: p.basicPrice);
    _vipPriceController = TextEditingController(text: p.vipPrice);
    _premiumPriceController = TextEditingController(text: p.premiumPrice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _workStartController.dispose();
    _workEndController.dispose();
    _descriptionController.dispose();
    _basicPriceController.dispose();
    _vipPriceController.dispose();
    _premiumPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditProfileWasherFormBody(
      nameController: _nameController,
      phoneController: _phoneController,
      addressController: _addressController,
      workStartController: _workStartController,
      workEndController: _workEndController,
      descriptionController: _descriptionController,
      basicPriceController: _basicPriceController,
      vipPriceController: _vipPriceController,
      premiumPriceController: _premiumPriceController,
      avatarNetworkImageUrl: widget.profile.avatarUrl,
      onCancel: () {
        if (context.canPop()) context.pop();
      },
      onSave: () {
      },
      onAvatarAction: () {},
    );
  }
}
