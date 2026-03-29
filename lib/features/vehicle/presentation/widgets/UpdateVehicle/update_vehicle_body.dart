import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/buttons/app_button_widget.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateInputField.dart';
import 'package:car_care/features/vehicle/presentation/widgets/UpdateVehicle/UpdateVehicleImage.dart';
import 'package:flutter/material.dart';
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
    final xFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (xFile != null) {
      setState(() => _pickedImage = xFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          UpdateVehicleImage(
            networkImage: widget.vehicle.image,
            pickedImagePath: _pickedImage?.path,
            onPickImage: pickImage,
          ),
          UpdateInputField(
            controller: brandController,
            hintText: 'الماركة',
            icon: Icons.local_offer_outlined,
          ),
          SizedBox(height: 12.h),
          UpdateInputField(
            controller: modelController,
            hintText: 'الموديل',
            icon: Icons.directions_car_filled_outlined,
          ),
          SizedBox(height: 12.h),
          UpdateInputField(
            controller: yearController,
            hintText: 'السنة',
            icon: Icons.calendar_month_outlined,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12.h),
          UpdateInputField(
            controller: plateController,
            hintText: 'رقم اللوحة',
            icon: Icons.sort_by_alpha,
          ),
          SizedBox(height: 12.h),
          UpdateInputField(
            controller: kmController,
            hintText: 'عداد الكيلومترات',
            icon: Icons.speed_outlined,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24.h),
         AppButton(
         text: 'حفظ التعديلات',
        backgroundColor: AppColors.orange,
        height: 54.h,         
       borderRadius: 15.r,
       fontSize: 20.sp,      
       onPressed: () {
       },
),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}