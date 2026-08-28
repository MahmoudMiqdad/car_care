// ignore_for_file: use_build_context_synchronously

import 'package:car_care/core/functions/upload_file_to_api.dart';

import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/core/widgets/selection/vehicle_selection_tile.dart';
import 'package:car_care/features/maintenance/user_requests/domain/repositories/i_requests_repository.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_cubit.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/cubit/add_maintenance_request_cubit/add_maintenance_request_state.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/models/maintenance_priority.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/photo_attachment_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/preferred_date_section.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/priority_selector.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/problem_description_field.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/requests_action_buttons.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/vehicle_info_section.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddRequestsPage extends StatelessWidget {
  const AddRequestsPage({super.key, required this.vehicleId});
  final String vehicleId;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AddMaintenanceRequestCubit(getIt<IRequestsRepository>()),
        ),
        BlocProvider(create: (_) => getIt<VehicleCubit>()..getAllVehicles()),
      ],
      child: _RequestsPageBody(vehicleId: vehicleId),
    );
  }
}

class _RequestsPageBody extends StatefulWidget {
  const _RequestsPageBody({required this.vehicleId});

  final String vehicleId;

  @override
  State<_RequestsPageBody> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<_RequestsPageBody> {
  final TextEditingController _problemController = TextEditingController();

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  MaintenancePriority _priority = MaintenancePriority.medium;

  VehicleEntity? _selectedVehicle;

  void _syncPreselectedVehicle(List<VehicleEntity> vehicles) {
    if (_selectedVehicle != null || vehicles.isEmpty) return;
    final preselectedId = int.tryParse(widget.vehicleId.trim());
    if (preselectedId == null) return;
    for (final v in vehicles) {
      if (v.id == preselectedId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedVehicle = v);
        });
        return;
      }
    }
  }

  Future<void> _pickVehicle() async {
    final l10n = context.l10n;
    final cubit = context.read<VehicleCubit>();
    var state = cubit.state;

    if (state is VehicleLoading) {
      await cubit.stream.firstWhere((s) => s is! VehicleLoading);
    }
    if (!mounted) return;
    state = cubit.state;

    if (state is VehicleError) {
      AppSnackBar.error(context, localizeErrorMessage(context, state.message));
      return;
    }

    if (state is VehicleEmpty ||
        (state is VehicleLoaded && state.vehicles.isEmpty)) {
      AppSnackBar.error(context, l10n.noVehiclesAddOneFirst);
      return;
    }

    if (state is! VehicleLoaded) return;
    final vehicles = state.vehicles;

    await SharedSelectionBottomSheet.show<VehicleEntity>(
      context: context,
      title: l10n.selectYourVehicle,
      items: vehicles,
      itemBuilder: (context, v) => VehicleSelectionTile(
        vehicle: v,
        isSelected: _selectedVehicle?.id == v.id,
        showImage: true,
        showPlateNumber: true,
      ),
      onSelected: (v) => setState(() => _selectedVehicle = v),
    );
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final l10n = context.l10n;
    final picked = await _picker.pickMultiImage(imageQuality: 80);

    if (picked.isEmpty) return;

    if (picked.length + _images.length > 3) {
      AppSnackBar.error(context, l10n.maxThreeImagesAllowed);
      return;
    }

    setState(() => _images.addAll(picked));
  }

  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final firstDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(firstDate) ? firstDate : selectedDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _submitRequest() async {
    final l10n = context.l10n;
    final vehicle = _selectedVehicle;
    if (vehicle == null) {
      AppSnackBar.error(context, l10n.pleaseSelectVehicleFirst);
      return;
    }

    if (_problemController.text.trim().isEmpty) {
      AppSnackBar.error(context, l10n.pleaseDescribeProblem);
      return;
    }

    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('vehicle_id', vehicle.id.toString()),
        MapEntry('description', _problemController.text.trim()),
        MapEntry('preferred_date', selectedDate.toIso8601String()),
        MapEntry('priority', _priority.name),
      ]);
      for (int i = 0; i < _images.length; i++) {
        final file = await uploadFiletoApi(_images[i]);
        if (file != null) {
          formData.files.add(MapEntry('images[$i]', file));
        }
      }

      context.read<AddMaintenanceRequestCubit>().addRequest(formData);
    } catch (_) {
      AppSnackBar.error(context, l10n.internalError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AddMaintenanceRequestCubit, AddMaintenanceRequestState>(
      listener: (context, state) {
        if (state is AddMaintenanceRequestSuccess) {
          AppSnackBar.success(context, l10n.requestSentSuccessfully);
          context.safePopOrGo(Routes.all_requests);
        }

        if (state is AddMaintenanceRequestError) {
          AppSnackBar.error(context, localizeErrorMessage(context, state.message));
        }
      },
      builder: (context, state) {
        final isLoading = state is AddMaintenanceRequestLoading;
        final cardR = RequestsFlowStyles.formCardRadius;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          appBar: CustomAppBar(
            title: l10n.maintenanceRequestTitle,
            showBackButton: true,
          ),
          body: RequestsFlowStyles.backgroundStack(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                18.w,
                12.h,
                16.w,
                24.h + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                children: [
                  BlocConsumer<VehicleCubit, VehicleState>(
                    listener: (context, vehicleState) {
                      if (vehicleState is VehicleLoaded) {
                        _syncPreselectedVehicle(vehicleState.vehicles);
                      }
                    },
                    builder: (context, vehicleState) => VehicleInfoSection(
                      cardRadius: cardR,
                      vehicle: _selectedVehicle,
                      onPickVehicle: _pickVehicle,
                      isLoading: isLoading,
                    ),
                  ),
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

                    submitLabel: isLoading
                        ? l10n.sendingRequest
                        : l10n.maintenanceRequestTitle,

                    cancelLabel: l10n.backButton,
                    onSubmit: isLoading ? null : _submitRequest,
                    onCancel: () => context.safePopOrGo(Routes.home),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
