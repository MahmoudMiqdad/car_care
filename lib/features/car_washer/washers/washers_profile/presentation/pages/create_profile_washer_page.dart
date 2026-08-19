import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_cubit.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/cubit/profile_washer_state.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_form.dart';
import 'package:car_care/features/car_washer/washers/washers_profile/presentation/widgets/create_profile_page/create_profile_washer_work_hours_section.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

void _profileWasherBack(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(Routes.home);
  }
}

class CreateProfileWasherPage extends StatelessWidget {
  const CreateProfileWasherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileWasherCubit>()..load(),
      child: const _CreateProfileWasherView(),
    );
  }
}

class _CreateProfileWasherView extends StatefulWidget {
  const _CreateProfileWasherView();

  @override
  State<_CreateProfileWasherView> createState() =>
      _CreateProfileWasherViewState();
}

class _CreateProfileWasherViewState extends State<_CreateProfileWasherView> {
  final _shop = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _desc = TextEditingController();
  final _basic = TextEditingController();
  final _vip = TextEditingController();
  final _premium = TextEditingController();
  final _services = TextEditingController(text: 'غسيل عادي, غسيل ممتاز, تلميع');
  final _workStart = TextEditingController(text: '11:00');
  final _workEnd = TextEditingController(text: '16:00');

  String? _logoPath;
  bool _waitingForSave = false;

  @override
  void dispose() {
    _shop.dispose();
    _phone.dispose();
    _city.dispose();
    _address.dispose();
    _desc.dispose();
    _basic.dispose();
    _vip.dispose();
    _premium.dispose();
    _services.dispose();
    _workStart.dispose();
    _workEnd.dispose();
    super.dispose();
  }

  List<String> _parseServices() => _services.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);

  Map<String, int> _parsePrices() {
    int p(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
    return {'basic': p(_basic), 'vip': p(_vip), 'premium': p(_premium)};
  }

  Map<String, String> _parseHours() {
    final start = _workStart.text.trim();
    final end = _workEnd.text.trim();
    final range = (start.isEmpty || end.isEmpty) ? '' : '$start-$end';
    return {'sat': range, 'sun': range};
  }

  Future<void> _pickWorkStart() =>
      profileWasherPickWorkTime(context, controller: _workStart);

  Future<void> _pickWorkEnd() => profileWasherPickWorkTime(
    context,
    controller: _workEnd,
    initial: const TimeOfDay(hour: 16, minute: 0),
  );

  Future<void> _pickLogo() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() => _logoPath = file.path);
  }

  void _save() {
    if (_shop.text.trim().isEmpty) {
      AppSnackBar.error(context, 'يرجى إدخال اسم المغسلة');
      return;
    }
    if (_phone.text.trim().isEmpty) {
      AppSnackBar.error(context, 'يرجى إدخال رقم الهاتف');
      return;
    }
    if (_city.text.trim().isEmpty) {
      AppSnackBar.error(context, 'يرجى إدخال المدينة');
      return;
    }

    _waitingForSave = true;
    context.read<ProfileWasherCubit>().saveProfile(
      shopName: _shop.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      address: _address.text.trim(),
      description: _desc.text.trim(),
      services: _parseServices(),
      servicePrices: _parsePrices(),
      workingHours: _parseHours(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ProfileWasherCubit, ProfileWasherState>(
      listener: (context, state) {
        if (state is ProfileWasherLoaded) {
          if (_waitingForSave) {
            _waitingForSave = false;
            AppSnackBar.success(context, 'تم إنشاء بروفايل المغسلة بنجاح');
            if (_logoPath != null) {
              context.read<ProfileWasherCubit>().uploadLogo(_logoPath!);
            }
          }
          context.go(Routes.profile_washer);
          return;
        }

        if (state is ProfileWasherError) {
          _waitingForSave = false;
          AppSnackBar.error(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileWasherLoading || state is ProfileWasherInitial) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.lightScaffold,
              body: const ImageBackground(
                child: Center(child: AppLoadingWidget()),
              ),
            ),
          );
        }

        final loading = state is ProfileWasherSaving;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.lightScaffold,
            appBar: CustomAppBar(
              title: l10n.profileWasherCreatePageTitle,
              showBackButton: true,
              backgroundColor: AppColors.carWashTeal,
              onBackTapped: () => _profileWasherBack(context),
            ),

            body: ImageBackground(
              child: CreateProfileWasherForm(
                isLoading: loading,
                logoPath: _logoPath,
                shopController: _shop,
                phoneController: _phone,
                cityController: _city,
                addressController: _address,
                descriptionController: _desc,
                servicesController: _services,
                basicController: _basic,
                vipController: _vip,
                premiumController: _premium,
                workStartController: _workStart,
                workEndController: _workEnd,
                onWorkStartTimeTap: _pickWorkStart,
                onWorkEndTimeTap: _pickWorkEnd,
                onPickLogo: _pickLogo,
                onSave: _save,
              ),
            ),
          ),
        );
      },
    );
  }
}
