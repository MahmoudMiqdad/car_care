import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/selection/governorate_selection_tile.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/core/widgets/selection/vehicle_selection_tile.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_state.dart';
import 'package:car_care/features/sos/presentation/widgets/create_sos/create_sos_body.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

class CreateSosPage extends StatefulWidget {
  const CreateSosPage({super.key});

  @override
  State<CreateSosPage> createState() => _CreateSosPageState();
}

class _CreateSosPageState extends State<CreateSosPage> {
  late final TextEditingController _descriptionController;

  String _vehicleValue = '';
  String _provinceValue = '';
  VehicleEntity? _selectedVehicle;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();

    Future.microtask(() {
      if (mounted) context.read<VehicleCubit>().getAllVehicles();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVehicle() async {
    final cubit = context.read<VehicleCubit>();
    var state = cubit.state;

    if (state is VehicleLoading) {
      await cubit.stream.firstWhere((s) => s is! VehicleLoading);
    }

    if (!mounted) return;

    state = cubit.state;

    if (state is VehicleError) {
      AppSnackBar.error(context, state.message);
      return;
    }

    if (state is VehicleEmpty) {
      AppSnackBar.error(context, 'لا توجد سيارات');
      return;
    }

    if (state is! VehicleLoaded) return;

    final vehicles = state.vehicles;

    FocusScope.of(context).unfocus();

    await SharedSelectionBottomSheet.show<VehicleEntity>(
      context: context,
      title: 'اختر مركبتك',
      items: vehicles,
      initialChildSize: vehicles.length > 4 ? 0.5 : 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.85,
      itemBuilder: (context, v) => VehicleSelectionTile(
        vehicle: v,
        isSelected: _selectedVehicle?.id == v.id,
        showImage: true,
        showPlateNumber: true,
      ),
      onSelected: (v) => setState(() {
        _selectedVehicle = v;
        _vehicleValue = '${v.brand} ${v.model}';
      }),
    );
  }

  Future<void> _pickProvince() async {
    await SharedSelectionBottomSheet.show<String>(
      context: context,
      title: 'اختر المحافظة',
      items: kCreateSosProvinceOptions,
      itemBuilder: (context, e) => GovernorateSelectionTile(
        label: e,
        isSelected: _provinceValue == e,
      ),
      onSelected: (e) => setState(() => _provinceValue = e),
    );
  }

  Future<void> _onSubmit() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    if (_selectedVehicle == null) {
      AppSnackBar.error(context, 'الرجاء اختيار السيارة');
      return;
    }

    if (_provinceValue.isEmpty) {
      AppSnackBar.error(context, 'الرجاء اختيار المحافظة');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      AppSnackBar.error(context, 'الرجاء وصف المشكلة');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() => _isSubmitting = false);
        AppSnackBar.error(context, 'يرجى تفعيل الموقع');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (!mounted) return;

      context.read<SosCubit>().createSos({
        'vehicle_id': _selectedVehicle!.id,
        'lat': position.latitude,
        'lng': position.longitude,
        'description': _descriptionController.text.trim(),
        'city': _provinceValue,
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);
      AppSnackBar.error(context, 'تعذر تحديد الموقع، حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SosCubit, SosState>(
      listener: (context, state) {
        if (state is SosCreated) {
          setState(() => _isSubmitting = false);

          final sos = state.sos;
          final id = sos.id;

          AppSnackBar.success(context, 'تم إرسال الطلب ✓');

          if (id != null) {
            context.pushReplacementNamed(
              'sosDetails',
              pathParameters: {'id': id.toString()},
            );
          } else {
            context.safePopOrGo(Routes.allUserSosRequests);
          }
        }

        if (state is SosError) {
          setState(() => _isSubmitting = false);
          AppSnackBar.error(context, state.message);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            title: l10n.createSosTitle,
            showBackButton: true,
            onBackTapped: () => context.safePopOrGo(Routes.home),
          ),
          body: ImageBackground(
            child: CreateSosBody(
              descriptionController: _descriptionController,
              vehicleValue: _vehicleValue,
              provinceValue: _provinceValue,
              onPickVehicle: _pickVehicle,
              onPickProvince: _pickProvince,
              onSubmit: _onSubmit,
              isLoading: _isSubmitting,
            ),
          ),
        ),
      ),
    );
  }
}
