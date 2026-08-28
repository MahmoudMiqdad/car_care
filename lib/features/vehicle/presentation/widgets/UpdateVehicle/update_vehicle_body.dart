import 'dart:typed_data';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_state.dart';
import 'package:car_care/features/vehicle/presentation/utils/vehicle_validators.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateVehicleImage.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVehicleBody extends StatefulWidget {
  final VehicleEntity vehicle;

  const UpdateVehicleBody({super.key, required this.vehicle});

  @override
  State<UpdateVehicleBody> createState() => _UpdateVehicleBodyState();
}

class _UpdateVehicleBodyState extends State<UpdateVehicleBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController kmController;
  late TextEditingController plateController;
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController yearController;

  late final String _initialKm;
  late final String _initialPlate;
  late final String _initialBrand;
  late final String _initialModel;
  late final String _initialYear;

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _initialKm = widget.vehicle.currentKm.toString();
    _initialPlate = widget.vehicle.plateNumber;
    _initialBrand = widget.vehicle.brand;
    _initialModel = widget.vehicle.model;
    _initialYear = widget.vehicle.year.toString();

    kmController = TextEditingController(text: _initialKm);
    plateController = TextEditingController(text: _initialPlate);
    brandController = TextEditingController(text: _initialBrand);
    modelController = TextEditingController(text: _initialModel);
    yearController = TextEditingController(text: _initialYear);
  }

  @override
  void dispose() {
    kmController.dispose();
    plateController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile != null) setState(() => _pickedImage = xFile);
  }

  Future<void> _submit(BuildContext context, {required bool isLoading}) async {
    if (!canSubmitVehicleForm(isLoading: isLoading)) return;
    if (_formKey.currentState?.validate() != true) return;

    Uint8List? bytes;
    String? name;
    if (_pickedImage != null) {
      final size = await _pickedImage!.length();
      final imageError = validateVehicleImageFile(
        fileName: _pickedImage!.name,
        sizeBytes: size,
      );
      if (!context.mounted) return;
      if (imageError != null) {
        AppSnackBar.error(context, imageError);
        return;
      }
      bytes = await _pickedImage!.readAsBytes();
      name = _pickedImage!.name;
    }

    final changedFields = buildVehicleUpdateFields(
      brand: brandController.text,
      initialBrand: _initialBrand,
      model: modelController.text,
      initialModel: _initialModel,
      year: yearController.text,
      initialYear: _initialYear,
      plateNumber: plateController.text,
      initialPlateNumber: _initialPlate,
      currentKm: kmController.text,
      initialCurrentKm: _initialKm,
    );

    if (changedFields.isEmpty && _pickedImage == null) {
      if (!context.mounted) return;
      AppSnackBar.error(context, context.l10n.noChangesMadeError);
      return;
    }

    if (!context.mounted) return;
    context.read<VehicleUpdateCubit>().updateVehicle(
      id: widget.vehicle.id,
      changedFields: changedFields,
      imageBytes: bytes,
      imageName: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return BlocProvider(
      create: (_) => getIt<VehicleUpdateCubit>(),
      child: BlocConsumer<VehicleUpdateCubit, VehicleUpdateState>(
        listener: (context, state) {
          if (state is VehicleUpdateSuccess) {
            AppSnackBar.success(context, strings.vehicleUpdatedSuccessfully);
            Navigator.of(context).pop(true);
          }
          if (state is VehicleUpdateError) {
            AppSnackBar.error(context, localizeErrorMessage(context, state.message));
          }
        },
        builder: (context, state) {
          final isLoading = state is VehicleUpdateLoading;

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    UpdateVehicleImage(
                      networkImage: widget.vehicle.image,
                      pickedImagePath: _pickedImage?.path,
                      onPickImage: pickImage,
                    ),
                    LoginTextField(
                      controller: kmController,
                      hintText: strings.odometer,
                      icon: Icons.speed_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validateVehicleCurrentKm(v, isRequired: false),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: plateController,
                      hintText: strings.plate,
                      icon: Icons.sort_by_alpha,
                      validator: (v) =>
                          validateVehiclePlateNumber(v, isRequired: false),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: brandController,
                      hintText: strings.brand,
                      icon: Icons.local_offer_outlined,
                      validator: (v) =>
                          validateVehicleBrand(v, isRequired: false),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: modelController,
                      hintText: strings.model,
                      icon: Icons.directions_car_filled_outlined,
                      validator: (v) =>
                          validateVehicleModel(v, isRequired: false),
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: yearController,
                      hintText: strings.year,
                      icon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          validateVehicleYear(v, isRequired: false),
                    ),
                    SizedBox(height: 14.h),
                    AppButton(
                      text: strings.saveChanges,
                      isLoading: isLoading,
                      height: 54.h,
                      borderRadius: 15.r,
                      fontSize: 20.sp,
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
