// صفحة تخصصات المتجر: نوع النشاط / ماركات السيارات / فئات القطع.
// كل بطاقة تُحدَّث وتُحفظ بشكل مستقل عبر POST /shop/profile (Payload كامل)
// مع الحفاظ على المجموعتين الأخريين واسم/هاتف/مدينة المتجر كما هي.
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/core/widgets/provider_status_page.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/presentation/cubit/owner_profile/owner_profile_state.dart';
import 'package:car_care/features/spare_parts_store/owner/specializations/presentation/widgets/owner_specialization_card.dart';
import 'package:car_care/features/spare_parts_store/shared/presentation/widgets/store_attribute_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerSpecializationsPage extends StatefulWidget {
  const OwnerSpecializationsPage({super.key});

  @override
  State<OwnerSpecializationsPage> createState() =>
      _OwnerSpecializationsPageState();
}

class _OwnerSpecializationsPageState extends State<OwnerSpecializationsPage> {
  late final OwnerProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OwnerProfileCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _saveGroup(
    OwnerProfileReady state, {
    List<int>? typeIds,
    List<int>? brandIds,
    List<int>? categoryIds,
  }) {
    final shop = state.shop;
    if (shop == null) return;
    _cubit.saveProfile(
      name: shop.name,
      phone: shop.phone ?? '',
      city: shop.city ?? '',
      businessTypeIds: typeIds ?? state.selectedTypeIds,
      carBrandIds: brandIds ?? state.selectedBrandIds,
      partCategoryIds: categoryIds ?? state.selectedCategoryIds,
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
          appBar: const CustomAppBar(title: 'تخصصات المتجر'),
          body: ImageBackground(
            child: BlocConsumer<OwnerProfileCubit, OwnerProfileState>(
              listener: (context, state) {
                if (state is! OwnerProfileReady) return;
                if (state.justSaved) {
                  AppSnackBar.success(context, 'تم تحديث التخصصات بنجاح');
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
                  if (state.shop == null) {
                    return const ProviderStatusPage(
                      status: ProviderApprovalStatus.pending,
                    );
                  }
                  final gate = buildProviderStatusGate(
                    state.shop!.status,
                    state.shop!.rejectionReason,
                  );
                  if (gate != null) return gate;

                  final isEnabled = !state.isSaving;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OwnerSpecializationCard(
                          title: 'نوع النشاط',
                          allOptions: SparePartsOptions.businessTypes,
                          selectedIds: state.selectedTypeIds,
                          attributeType: StoreAttributeType.businessType,
                          isEnabled: isEnabled,
                          onChanged: (ids) => _saveGroup(state, typeIds: ids),
                        ),
                        SizedBox(height: 12.h),
                        OwnerSpecializationCard(
                          title: 'ماركات السيارات',
                          allOptions: SparePartsOptions.carBrands,
                          selectedIds: state.selectedBrandIds,
                          attributeType: StoreAttributeType.carBrand,
                          isEnabled: isEnabled,
                          onChanged: (ids) => _saveGroup(state, brandIds: ids),
                        ),
                        SizedBox(height: 12.h),
                        OwnerSpecializationCard(
                          title: 'فئات القطع',
                          allOptions: SparePartsOptions.partCategories,
                          selectedIds: state.selectedCategoryIds,
                          attributeType: StoreAttributeType.partCategory,
                          isEnabled: isEnabled,
                          onChanged: (ids) =>
                              _saveGroup(state, categoryIds: ids),
                        ),
                      ],
                    ),
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
