// صفحة ملف متجر المالك — التنسيق والتحكم.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_state.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/widgets/owner_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({super.key});

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  late final OwnerProfileCubit _cubit;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  List<int> _selectedTypeIds = [];
  List<int> _selectedBrandIds = [];
  List<int> _selectedCategoryIds = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OwnerProfileCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _initFromState(OwnerProfileReady state) {
    if (_initialized) return;
    _initialized = true;
    final shop = state.shop;
    if (shop != null) {
      _nameCtrl.text = shop.name;
      _phoneCtrl.text = shop.phone ?? '';
      _cityCtrl.text = shop.city ?? '';
    }
    setState(() {
      _selectedTypeIds = List.of(state.selectedTypeIds);
      _selectedBrandIds = List.of(state.selectedBrandIds);
      _selectedCategoryIds = List.of(state.selectedCategoryIds);
    });
  }

  void _onSave() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    if (name.isEmpty || phone.isEmpty || city.isEmpty) {
      AppSnackBar.error(context, 'يرجى تعبئة جميع الحقول المطلوبة');
      return;
    }
    _cubit.saveProfile(
      name: name,
      phone: phone,
      city: city,
      businessTypeIds: _selectedTypeIds,
      carBrandIds: _selectedBrandIds,
      partCategoryIds: _selectedCategoryIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBar(title: 'ملف المتجر'),
          body: ImageBackground(
            child: BlocConsumer<OwnerProfileCubit, OwnerProfileState>(
              listener: (context, state) {
                if (state is! OwnerProfileReady) return;
                _initFromState(state);
                if (state.justSaved) {
                  setState(() {
                    _selectedTypeIds = List.of(state.selectedTypeIds);
                    _selectedBrandIds = List.of(state.selectedBrandIds);
                    _selectedCategoryIds = List.of(state.selectedCategoryIds);
                  });
                  AppSnackBar.success(context, 'تم حفظ المتجر بنجاح');
                  _cubit.clearJustSaved();
                }
                if (state.saveError != null) {
                  AppSnackBar.error(context, state.saveError!);
                  _cubit.clearSaveError();
                }
              },
              builder: (context, state) {
                if (state is OwnerProfileLoading) {
                  return const AppLoadingWidget();
                }
                if (state is OwnerProfileError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: _cubit.loadProfile,
                  );
                }
                if (state is OwnerProfileReady) {
                  if (state.shop != null) {
                    final gate = buildProviderStatusGate(
                      state.shop!.status,
                      state.shop!.rejectionReason,
                    );
                    if (gate != null) return gate;
                  }
                  return OwnerProfileBody(
                    nameCtrl: _nameCtrl,
                    phoneCtrl: _phoneCtrl,
                    cityCtrl: _cityCtrl,
                    selectedTypeIds: _selectedTypeIds,
                    selectedBrandIds: _selectedBrandIds,
                    selectedCategoryIds: _selectedCategoryIds,
                    onTypeIdsChanged: (ids) =>
                        setState(() => _selectedTypeIds = ids),
                    onBrandIdsChanged: (ids) =>
                        setState(() => _selectedBrandIds = ids),
                    onCategoryIdsChanged: (ids) =>
                        setState(() => _selectedCategoryIds = ids),
                    onSave: _onSave,
                    isNew: state.shop == null,
                    isEnabled: !state.isSaving,
                    isSaving: state.isSaving,
                    unknownValues: state.unknownValues,
                    status: state.shop?.status,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
