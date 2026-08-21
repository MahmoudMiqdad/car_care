import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/location_helper.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/selection/governorate_selection_tile.dart';
import 'package:car_care/core/widgets/selection/shared_selection_bottom_sheet.dart';
import 'package:car_care/core/widgets/selection/vehicle_selection_tile.dart';
import 'package:car_care/features/user_fuel/domain/entities/user_fuel_order_entity.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_cubit.dart';
import 'package:car_care/features/user_fuel/presentation/cubit/user_fuel_cubit/user_fuel_state.dart';
import 'package:car_care/features/user_fuel/presentation/widgets/fuel_sos_create/fuel_sos_create_body.dart';
import 'package:car_care/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_cubit.dart';
import 'package:car_care/features/vehicle/presentation/cubit/vehicle_cubit/vehicle_state.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> _goToDetailsThenBack(
  BuildContext context,
  UserFuelOrderEntity order,
) async {
  await context.push(Routes.fuel_order_details, extra: order);
  if (context.mounted) {
    context.safePopOrGo(Routes.fuelorderslist, result: true);
  }
}

class FuelSosCreatePage extends StatefulWidget {
  const FuelSosCreatePage({super.key});

  @override
  State<FuelSosCreatePage> createState() => _FuelSosCreatePageState();
}

class _FuelSosCreatePageState extends State<FuelSosCreatePage> {
  late final TextEditingController _quantityController;
  late final TextEditingController _notesController;

  String? _vehicleValue;
  int? _vehicleId;

  String? _fuelTypeValue;

  String? _fuelTypeApiValue;
  String? _provinceValue;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
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
      AppSnackBar.error(context, state.message);
      return;
    }

    if (state is VehicleEmpty) {
      AppSnackBar.error(context, l10n.noVehiclesAdded);
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
        isSelected: _vehicleId == v.id,
        showImage: true,
        showPlateNumber: true,
      ),
      onSelected: (v) => setState(() {
        _vehicleValue = '${v.brand} ${v.model}';
        _vehicleId = v.id;
      }),
    );
  }

  List<({String label, String apiValue})> _fuelTypeOptions(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    return [
      (label: l10n.gasoline95, apiValue: '95'),
      (label: l10n.gasoline98, apiValue: '98'),
      (label: l10n.diesel, apiValue: 'diesel'),
    ];
  }

  Future<void> _pickFuelType() async {
    final l10n = context.l10n;
    final options = _fuelTypeOptions(context);

    await SharedSelectionBottomSheet.show<({String label, String apiValue})>(
      context: context,
      title: l10n.fuelSosCreateFuelTypeHint,
      items: options,
      itemBuilder: (context, option) => GovernorateSelectionTile(
        label: option.label,
        isSelected: option.apiValue == _fuelTypeApiValue,
      ),

      onSelected: (choice) => setState(() {
        _fuelTypeValue = choice.label;
        _fuelTypeApiValue = choice.apiValue;
      }),
    );
  }

  Future<void> _pickProvince() async {
    await SharedSelectionBottomSheet.show<String>(
      context: context,
      title: context.l10n.selectGovernorate,
      items: kCreateSosProvinceOptions,
      itemBuilder: (context, e) =>
          GovernorateSelectionTile(label: e, isSelected: _provinceValue == e),
      onSelected: (e) => setState(() => _provinceValue = e),
    );
  }

  Future<void> _onSubmit() async {
    if (_isSubmitting) return;

    final l10n = context.l10n;
    FocusScope.of(context).unfocus();

    final fuelTypeApiValue = _fuelTypeApiValue;

    if (_vehicleId == null ||
        fuelTypeApiValue == null ||
        _quantityController.text.isEmpty ||
        _provinceValue == null) {
      AppSnackBar.error(context, l10n.completeAllFieldsError);
      return;
    }

    setState(() => _isSubmitting = true);
    final location = await getCurrentLocation();
    if (!mounted) return;

    if (!location.isSuccess) {
      setState(() => _isSubmitting = false);
      AppSnackBar.error(context, location.errorMessage!);
      return;
    }

    final position = location.position!;

    context.read<UserFuelCubit>().addEmergencyOrder({
      'vehicle_id': _vehicleId,
      'fuel_type': fuelTypeApiValue,
      'amount': double.tryParse(_quantityController.text) ?? 0,
      'delivery_latitude': position.latitude,
      'delivery_longitude': position.longitude,
      'city': _provinceValue,
      'notes': _notesController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: l10n.fuelSosCreateTitle,
        showBackButton: true,
        onBackTapped: () => context.safePopOrGo(Routes.home),
      ),
      body: BlocListener<UserFuelCubit, UserFuelState>(
        listener: (context, state) {
          if (state is UserFuelOrderCreated) {
            setState(() => _isSubmitting = false);
            AppSnackBar.success(context, l10n.fuelOrderSentSuccessfully);
            _goToDetailsThenBack(context, state.order);
          }
          if (state is UserFuelError) {
            setState(() => _isSubmitting = false);
            final msg =
                state.message.isEmpty || state.message.startsWith('Instance of')
                ? l10n.sosGenericActionError
                : state.message;
            AppSnackBar.error(context, msg);
          }
        },
        child: ImageBackground(
          child: FuelSosCreateBody(
            vehicleValue: _vehicleValue,
            fuelTypeValue: _fuelTypeValue,
            provinceValue: _provinceValue,
            quantityController: _quantityController,
            notesController: _notesController,
            onPickVehicle: _pickVehicle,
            onPickFuelType: _pickFuelType,
            onPickProvince: _pickProvince,
            onSubmit: _onSubmit,
            isLoading: _isSubmitting,
          ),
        ),
      ),
    );
  }
}
