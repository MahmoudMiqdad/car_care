import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/functions/upload_file_to_api.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/photo_attachment_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/preferred_date_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/priority_selector.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/problem_description_field.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/requests_action_buttons.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_page/vehicle_info_section.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddRequestsPage extends StatelessWidget {
  const AddRequestsPage({super.key, required this.vehicleId});
  final String vehicleId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMaintenanceRequestCubit(getIt<IRequestsRepository>()),
      child: const _RequestsPageBody(),
    );
  }
}

class _RequestsPageBody extends StatefulWidget {
  const _RequestsPageBody();

  @override
  State<_RequestsPageBody> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<_RequestsPageBody> {
  final TextEditingController _problemController = TextEditingController();

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  DateTime selectedDate = DateTime.now();
  MaintenancePriority _priority = MaintenancePriority.medium;

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);

    if (picked.isEmpty) return;

    if (picked.length + _images.length > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يمكنك اختيار 3 صور كحد أقصى'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _images.addAll(picked));
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

  void _submitRequest() async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        const MapEntry('vehicle_id', '3'),
        MapEntry('description', _problemController.text),
        MapEntry('preferred_date', selectedDate.toIso8601String()),
        MapEntry('priority', _priority.name),
      ]);
      for (int i = 0; i < _images.length; i++) {
        final file = await uploadFileToApi(_images[i]);
        if (file != null) {
          formData.files.add(MapEntry('images[$i]', file));
        }
      }

      context.read<AddMaintenanceRequestCubit>().addRequest(formData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ داخلي: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMaintenanceRequestCubit, AddMaintenanceRequestState>(
      listener: (context, state) {
        if (state is AddMaintenanceRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال الطلب بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is AddMaintenanceRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddMaintenanceRequestLoading;
        final cardR = RequestsFlowStyles.formCardRadius;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.lightScaffold,
            appBar: const CustomAppBar(
              title: 'طلب صيانة',
              showBackButton: true,
            ),
            bottomNavigationBar: HomeBottomNavBar(
              onItemSelected: (index) {
                if (index == 0) context.go(Routes.home);
              },
            ),
            body: RequestsFlowStyles.backgroundStack(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(18.w, 12.h, 16.w, 24.h),
                child: Column(
                  children: [
                    VehicleInfoSection(cardRadius: cardR),
                    ProblemDescriptionField(controller: _problemController),
                  SizedBox(height: 8.h),
                    PhotoAttachmentSection(
                      cardRadius: cardR,
                      images: _images,
                      onAddPhoto: _pickImages,
                      onRemove: (img) => setState(() => _images.remove(img)),
                    ),
                    SizedBox(height: 8.h),
                    PreferredDateSection(
                      cardRadius: cardR,
                      formattedDate: selectedDate,
                      onPickDate: _pickDate,
                    ),
                   SizedBox(height: 8.h),
                    PrioritySelector(
                      selected: _priority,
                      onChanged: (p) => setState(() => _priority = p),
                    ),
                     SizedBox(height: 8.h),
                    RequestsActionButtons(
                      cardRadius: cardR,
                      onSubmit: isLoading ? null : _submitRequest,
                      onCancel: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
