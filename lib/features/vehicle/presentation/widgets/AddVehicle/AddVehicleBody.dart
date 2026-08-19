// ignore_for_file: file_names
import 'dart:typed_data';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';

import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';

import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_state.dart';
import 'package:car_care/features/vehicle/presentation/utils/vehicle_validators.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/SaveVehicleButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/VehicleImageWidget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


class AddVehicleBody extends StatefulWidget {
  const AddVehicleBody({super.key});

  @override
  State<AddVehicleBody> createState() => _AddVehicleBodyState();
}

class _AddVehicleBodyState extends State<AddVehicleBody> {
  final _formKey = GlobalKey<FormState>();

  final _kmController = TextEditingController();
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  XFile? _pickedImage;

  @override
  void dispose() {
    _kmController.dispose();
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile == null) return;
    setState(() => _pickedImage = xFile);
  }

  Future<void> _submit(BuildContext context, {required bool isLoading}) async {
    final l10n = context.l10n;
    if (!canSubmitVehicleForm(isLoading: isLoading)) return;

    if (_pickedImage == null) {
      AppSnackBar.error(context, l10n.pleaseSelectVehicleImageError);
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    final String fileName = _pickedImage!.name;
    final size = await _pickedImage!.length();
    
    if (!mounted) return;
    final imageError = validateVehicleImageFile(
      fileName: fileName,
      sizeBytes: size,
      l10n: l10n,
    );
    
    if (imageError != null) {
      AppSnackBar.error(context, imageError);
      return;
    }

    final Uint8List bytes = await _pickedImage!.readAsBytes();

    if (!mounted) return;
    context.read<VehicleAddCubit>().addVehicle(
      brand: _brandController.text,
      model: _modelController.text,
      year: _yearController.text,
      plateNumber: _plateController.text,
      currentKm: _kmController.text,
      imageBytes: bytes,
      imageFileName: fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocProvider(
      create: (_) => getIt<VehicleAddCubit>(),
      child: BlocConsumer<VehicleAddCubit, VehicleAddState>(
        listener: (context, state) {
          if (state is VehicleAddSuccess) {
            AppSnackBar.success(context, strings.vehicleAddedSuccess);
            context.pop(true);
          }
          if (state is VehicleAddError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is VehicleAddLoading;

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    VehicleImageWidget(
                      imagePath: _pickedImage?.path,
                      onPickImage: _pickImage,
                    ),
                    LoginTextField(
                      innerBorderColor: AppColors.transparent,
                      controller: _kmController,
                      hintText: strings.odometer,
                      icon: Icons.speed_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validateVehicleCurrentKm(v, isRequired: true, l10n: strings),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      innerBorderColor: AppColors.transparent,
                      controller: _plateController,
                      hintText: strings.plateNumber,
                      icon: Icons.sort_by_alpha,
                      validator: (v) =>
                          validateVehiclePlateNumber(v, isRequired: true, l10n: strings),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      innerBorderColor: AppColors.transparent,
                      controller: _brandController,
                      hintText: strings.brand,
                      icon: Icons.local_offer_outlined,
                      validator: (v) =>
                          validateVehicleBrand(v, isRequired: true, l10n: strings),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      innerBorderColor: AppColors.transparent,
                      controller: _modelController,
                      hintText: strings.model,
                      icon: Icons.directions_car_filled_outlined,
                      validator: (v) =>
                          validateVehicleModel(v, isRequired: true, l10n: strings),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      innerBorderColor: AppColors.transparent,
                      controller: _yearController,
                      hintText: strings.year,
                      icon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validateVehicleYear(v, isRequired: true, l10n: strings),
                    ),
                    SizedBox(height: 16.h),
                    SaveVehicleButton(
                      isLoading: isLoading,
                      onPressed: canSubmitVehicleForm(isLoading: isLoading)
                          ? () => _submit(context, isLoading: isLoading)
                          : null,
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
