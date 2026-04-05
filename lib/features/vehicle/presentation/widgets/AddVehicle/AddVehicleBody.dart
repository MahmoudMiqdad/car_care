// ignore_for_file: file_names
import 'dart:typed_data';
import 'package:car_care/core/service_locator/service_locator.dart';

import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';


import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/SaveVehicleButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/VehicleImageWidget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleBody extends StatefulWidget {
  const AddVehicleBody({super.key});

  @override
  State<AddVehicleBody> createState() => _AddVehicleBodyState();
}

class _AddVehicleBodyState extends State<AddVehicleBody> {
  
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

  Future<void>  _submit(BuildContext context) async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة للمركبة')),
      );
      return;
    }

    if (_kmController.text.trim().isEmpty ||
        _plateController.text.trim().isEmpty ||
        _brandController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')),
      );
      return;
    }

    final Uint8List bytes = await _pickedImage!.readAsBytes();
    final String fileName = _pickedImage!.name;

    // ignore: use_build_context_synchronously
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة المركبة بنجاح')),
            );
            Navigator.of(context).pop(true);
          }
          if (state is VehicleAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is VehicleAddLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    VehicleImageWidget(
                      imagePath: _pickedImage?.path,
                      onPickImage: _pickImage,
                    ),
                    LoginTextField(
                      controller: _kmController,
                      hintText: strings.odometer,
                      icon: Icons.speed_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: _plateController,
                      hintText: strings.plateNumber,
                      icon: Icons.sort_by_alpha,
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: _brandController,
                      hintText: strings.brand,
                      icon: Icons.local_offer_outlined,
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: _modelController,
                      hintText: strings.model,
                      icon: Icons.directions_car_filled_outlined,
                    ),
                    SizedBox(height: 10.h),
                    LoginTextField(
                      controller: _yearController,
                      hintText: strings.year,
                      icon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    SaveVehicleButton(
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _submit(context),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
              if (isLoading)
                const Positioned.fill(child: Center(child: AppLoadingWidget())),
            ],
          );
        },
      ),
    );
  }
}