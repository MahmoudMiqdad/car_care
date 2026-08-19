import 'package:car_care/core/constants/list_province.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/location_helper.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
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

  /// Label shown in the form.
  String? _fuelTypeValue;

  /// Exact value sent as `fuel_type` — set only from the options list.
  String? _fuelTypeApiValue;
  String? _provinceValue;

  /// True while the device GPS fix is being acquired, before the request.
  bool _resolvingLocation = false;

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

    final choice = await showModalBottomSheet<VehicleEntity>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: vehicles.map((v) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: v.image != null && v.image!.isNotEmpty
                      ? NetworkImage(v.image!)
                      : null,
                  child: v.image == null || v.image!.isEmpty
                      ? const Icon(Icons.directions_car, size: 18)
                      : null,
                ),
                title: Text('${v.brand} ${v.model}'),
                subtitle: Text('${v.year} • ${v.plateNumber}'),
                onTap: () => Navigator.pop(context, v),
              );
            }).toList(),
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    setState(() {
      _vehicleValue = '${choice.brand} ${choice.model}';
      _vehicleId = choice.id;
    });
  }

  /// Fuel types accepted by the backend. 91 is intentionally absent — the
  /// API rejects it with "The selected fuel type is invalid".
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
    final options = _fuelTypeOptions(context);

    final choice =
        await showModalBottomSheet<({String label, String apiValue})>(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) {
            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((e) {
                  return ListTile(
                    title: Text(e.label),
                    onTap: () => Navigator.pop(context, e),
                  );
                }).toList(),
              ),
            );
          },
        );

    if (!mounted || choice == null) return;
    // Store the API value alongside the label so submit never has to
    // re-derive it from the displayed text.
    setState(() {
      _fuelTypeValue = choice.label;
      _fuelTypeApiValue = choice.apiValue;
    });
  }

  Future<void> _pickProvince() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: kCreateSosProvinceOptions.map((e) {
                  return ListTile(
                    title: Text(e),
                    onTap: () => Navigator.pop(context, e),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    setState(() => _provinceValue = choice);
  }

  Future<void> _onSubmit() async {
    final l10n = context.l10n;
    // Prevent duplicate taps while the GPS fix is in flight.
    if (_resolvingLocation) return;

    FocusScope.of(context).unfocus();

    final fuelTypeApiValue = _fuelTypeApiValue;

    if (_vehicleId == null ||
        fuelTypeApiValue == null ||
        _quantityController.text.isEmpty ||
        _provinceValue == null) {
      AppSnackBar.error(context, l10n.completeAllFieldsError);
      return;
    }

    // Real device GPS — the request is aborted rather than falling back to
    // fake coordinates.
    setState(() => _resolvingLocation = true);
    final location = await getCurrentLocation();
    if (!mounted) return;
    setState(() => _resolvingLocation = false);

    if (!location.isSuccess) {
      AppSnackBar.error(context, location.errorMessage!);
      return;
    }

    final position = location.position!;

    if (!mounted) return;
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
            AppSnackBar.success(context, l10n.fuelOrderSentSuccessfully);
            // Show the details page, then pop this form too on the way
            // back so back doesn't return to a filled page — same net
            // effect as pushReplacement, but as two real pops so the
            // originating list page's awaited push resolves and can
            // refresh itself exactly once.
            _goToDetailsThenBack(context, state.order);
          }
          if (state is UserFuelError) {
            final msg =
                state.message.isEmpty ||
                    state.message.startsWith('Instance of')
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
          ),
        ),
      ),
    );
  }
}