import 'dart:io';
import 'dart:typed_data';

import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/app_loading_widget.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_add_cubit/vehicle_add_state.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/SaveVehicleButton.dart';
import 'package:car_care/features/vehicle/presentation/widgets/AddVehicle/VehicleImageWidget.dart';
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

    setState(() {
      _pickedImage = xFile;
    });
  }

  Future<void> _submit(BuildContext context) async {
    debugPrint('SUBMIT CLICKED ');

    if (_pickedImage == null) {
      debugPrint('NO IMAGE ');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة للمركبة')),
      );
      return;
    }

    debugPrint('IMAGE OK ');

    if (_kmController.text.trim().isEmpty ||
        _plateController.text.trim().isEmpty ||
        _brandController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty ||
        _yearController.text.trim().isEmpty) {
      debugPrint('FIELDS EMPTY');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')));
      return;
    }

    debugPrint('FIELDS OK');

    final Uint8List bytes = await _pickedImage!.readAsBytes();
    final String fileName = _pickedImage!.name;

    debugPrint('BYTES LENGTH = ${bytes.length}, NAME = $fileName ');

    context.read<VehicleAddCubit>().addVehicle(
      brand: _brandController.text,
      model: _modelController.text,
      year: _yearController.text,
      plateNumber: _plateController.text,
      currentKm: _kmController.text,
      imageBytes: bytes,
      imageFileName: fileName,
    );

    debugPrint('CUBIT CALLED ');
  }

  @override
  Widget build(BuildContext context) {
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                    _InputField(
                      controller: _kmController,
                      hintText: 'عداد الكيلومترات',
                      icon: Icon(
                        Icons.speed_outlined,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12.h),
                    _InputField(
                      controller: _plateController,
                      hintText: 'اللوحة',
                      icon: Icon(
                        Icons.sort_by_alpha,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _InputField(
                      controller: _brandController,
                      hintText: 'الماركة',
                      icon: Icon(
                        Icons.local_offer_outlined,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _InputField(
                      controller: _modelController,
                      hintText: 'الموديل',
                      icon: Icon(
                        Icons.directions_car_filled_outlined,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _InputField(
                      controller: _yearController,
                      hintText: 'السنة',
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
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

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.5.w),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          icon,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
