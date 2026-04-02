import 'dart:typed_data';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/auth/presentation/widgets/login/login_text_field.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/update_vehicle/vehicle_update_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateVehicleImage.dart';
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
  late TextEditingController kmController;
  late TextEditingController plateController;
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController yearController;

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    kmController = TextEditingController(text: widget.vehicle.currentKm.toString());
    plateController = TextEditingController(text: widget.vehicle.plateNumber);
    brandController = TextEditingController(text: widget.vehicle.brand);
    modelController = TextEditingController(text: widget.vehicle.model);
    yearController = TextEditingController(text: widget.vehicle.year.toString());
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

  bool _isAnyFieldEmpty() {
    return brandController.text.trim().isEmpty ||
        modelController.text.trim().isEmpty ||
        yearController.text.trim().isEmpty ||
        plateController.text.trim().isEmpty ||
        kmController.text.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehicleUpdateCubit>(),
      child: BlocConsumer<VehicleUpdateCubit, VehicleUpdateState>(
        listener: (context, state) {
          if (state is VehicleUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث المركبة بنجاح')),
            );
            Navigator.of(context).pop(true);
          }
          if (state is VehicleUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is VehicleUpdateLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                UpdateVehicleImage(
                  networkImage: widget.vehicle.image,
                  pickedImagePath: _pickedImage?.path,
                  onPickImage: pickImage,
                ),
                LoginTextField(
                  controller: kmController,
                  hintText: 'عداد الكيلومترات',
                  icon: Icons.speed_outlined,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10.h),
                LoginTextField(
                  controller: plateController,
                  hintText: 'اللوحة',
                  icon: Icons.sort_by_alpha,
                ),
                SizedBox(height: 10.h),
                LoginTextField(
                  controller: brandController,
                  hintText: 'الماركة',
                  icon: Icons.local_offer_outlined,
                ),
                SizedBox(height: 10.h),
                LoginTextField(
                  controller: modelController,
                  hintText: 'الموديل',
                  icon: Icons.directions_car_filled_outlined,
                ),
                SizedBox(height: 10.h),
                LoginTextField(
                  controller: yearController,
                  hintText: 'السنة',
                  icon: Icons.calendar_month_outlined,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                AppButton(
                  text: isLoading ? 'جارٍ الحفظ...' : 'حفظ التعديلات',
                  backgroundColor: AppColors.orange,
                  height: 54.h,
                  borderRadius: 15.r,
                  fontSize: 20.sp,
                  onPressed: () async {
                    if (isLoading) return;
                    if (_isAnyFieldEmpty()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')),
                      );
                      return;
                    }

                    Uint8List? bytes;
                    String? name;
                    if (_pickedImage != null) {
                      bytes = await _pickedImage!.readAsBytes();
                      name = _pickedImage!.name;
                    }
                    // ignore: use_build_context_synchronously
                    context.read<VehicleUpdateCubit>().updateVehicle(
                          id: widget.vehicle.id,
                          brand: brandController.text,
                          model: modelController.text,
                          year: yearController.text,
                          plateNumber: plateController.text,
                          currentKm: kmController.text,
                          imageBytes: bytes,
                          imageName: name,
                        );
                  },
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }
}