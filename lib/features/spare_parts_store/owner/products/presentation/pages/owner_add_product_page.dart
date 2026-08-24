import 'dart:io';

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/functions/upload_file_to_api.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/spare_parts_store/owner/profile/data/static/spare_parts_options.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_cubit.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/cubit/owner_products/owner_products_state.dart';
import 'package:car_care/features/spare_parts_store/owner/products/presentation/widgets/single_select_options_sheet.dart';
import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

const int _kMaxProductImages = 5;

const int _kNoSelection = -1;

class OwnerAddProductPage extends StatefulWidget {
  const OwnerAddProductPage({super.key});

  @override
  State<OwnerAddProductPage> createState() => _OwnerAddProductPageState();
}

class _OwnerAddProductPageState extends State<OwnerAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  String _condition = 'new';
  int? _carBrandId;
  int? _partCategoryId;
  final List<XFile> _images = [];

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final remaining = _kMaxProductImages - _images.length;
    if (remaining <= 0) return;
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isEmpty || !mounted) return;
    setState(() => _images.addAll(picked.take(remaining)));
  }

  void _removeImage(XFile file) => setState(() => _images.remove(file));

  Future<void> _pickCondition() async {
    final l10n = context.l10n;
    final conditionLabels = <String, String>{
      'new': l10n.conditionNew,
      'used': l10n.conditionUsed,
    };
    final result = await SingleSelectOptionsSheet.show<String>(
      context,
      title: l10n.productCondition,
      items: conditionLabels.entries.map((e) => (e.key, e.value)).toList(),
      currentValue: _condition,
    );
    if (result != null && mounted) setState(() => _condition = result);
  }

  Future<void> _pickOption({
    required String title,
    required List<SparePartsOption> options,
    required int? currentId,
    required ValueChanged<int?> onPicked,
  }) async {
    final l10n = context.l10n;
    final result = await SingleSelectOptionsSheet.show<int>(
      context,
      title: title,
      items: [
        (_kNoSelection, l10n.noSelection),
        ...options.map((o) => (o.id, o.name)),
      ],
      currentValue: currentId ?? _kNoSelection,
    );
    if (result == null || !mounted) return;
    onPicked(result == _kNoSelection ? null : result);
  }

  Future<void> _submit(OwnerProductsCubit cubit) async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final formData = FormData();
    formData.fields.addAll([
      MapEntry('name', _nameCtrl.text.trim()),
      if (_descCtrl.text.trim().isNotEmpty)
        MapEntry('description', _descCtrl.text.trim()),
      MapEntry('price', _priceCtrl.text.trim()),
      MapEntry('stock_quantity', _stockCtrl.text.trim()),
      MapEntry('condition', _condition),
      if (_carBrandId != null) MapEntry('car_brand_id', _carBrandId.toString()),
      if (_partCategoryId != null)
        MapEntry('part_category_id', _partCategoryId.toString()),
    ]);
    for (var i = 0; i < _images.length; i++) {
      final file = await uploadFiletoApi(_images[i]);
      if (file != null) formData.files.add(MapEntry('images[$i]', file));
    }
    if (!mounted) return;
    cubit.createProduct(formData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<OwnerProductsCubit>();
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: CustomAppBar(title: l10n.addProduct),
      body: ImageBackground(
        child: BlocConsumer<OwnerProductsCubit, OwnerProductsState>(
          listener: (context, state) {
            if (!_submitting || state is! OwnerProductsLoaded) return;
            if (state.isCreating) return;
            setState(() => _submitting = false);
            if (state.createError != null) {
              AppSnackBar.error(context, state.createError!);
              cubit.clearCreateError();
            } else {
              AppSnackBar.success(context, l10n.productAddedSuccessfully);
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final isCreating = state is OwnerProductsLoaded && state.isCreating;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(l10n.basicInformation),
                          SizedBox(height: 10.h),
                          _labeledField(
                            controller: _nameCtrl,
                            label: l10n.productName,
                            fieldKey: const Key('add_product_name_field'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.productNameRequired
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          _labeledField(
                            controller: _descCtrl,
                            label: l10n.description,
                            maxLines: 2,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: _labeledField(
                                  controller: _priceCtrl,
                                  label: l10n.price,
                                  fieldKey: const Key(
                                    'add_product_price_field',
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (v) {
                                    final parsed = double.tryParse(
                                      (v ?? '').trim(),
                                    );
                                    if (parsed == null || parsed < 0) {
                                      return l10n.enterValidPrice;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _labeledField(
                                  controller: _stockCtrl,
                                  label: l10n.availableQuantity,
                                  fieldKey: const Key(
                                    'add_product_stock_field',
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    final parsed = int.tryParse(
                                      (v ?? '').trim(),
                                    );
                                    if (parsed == null || parsed < 0) {
                                      return l10n.enterValidQuantity;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _sectionTitle(l10n.classification),
                          SizedBox(height: 10.h),
                          _classificationRow(
                            label: l10n.productCondition,
                            value: _conditionLabel(l10n, _condition),
                            color: AppColors.accent,
                            onTap: _pickCondition,
                          ),
                          SizedBox(height: 10.h),
                          _classificationRow(
                            label: l10n.carBrand,
                            value: _optionLabel(
                              l10n,
                              SparePartsOptions.carBrands,
                              _carBrandId,
                            ),
                            color: AppColors.green,
                            onTap: () => _pickOption(
                              title: l10n.carBrand,
                              options: SparePartsOptions.carBrands,
                              currentId: _carBrandId,
                              onPicked: (id) =>
                                  setState(() => _carBrandId = id),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _classificationRow(
                            label: l10n.partCategory,
                            value: _optionLabel(
                              l10n,
                              SparePartsOptions.partCategories,
                              _partCategoryId,
                            ),
                            color: AppColors.accent,
                            onTap: () => _pickOption(
                              title: l10n.partCategory,
                              options: SparePartsOptions.partCategories,
                              currentId: _partCategoryId,
                              onPicked: (id) =>
                                  setState(() => _partCategoryId = id),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _sectionTitle(l10n.productImages),
                          SizedBox(height: 10.h),
                          _imagesSection(l10n),
                        ],
                      ),
                    ),
                  ),
                ),
                _saveBar(l10n: l10n, isCreating: isCreating, cubit: cubit),
              ],
            );
          },
        ),
      ),
    );
  }

  String _conditionLabel(AppLocalizations l10n, String condition) {
    switch (condition) {
      case 'used':
        return l10n.conditionUsed;
      case 'new':
      default:
        return l10n.conditionNew;
    }
  }

  String _optionLabel(
    AppLocalizations l10n,
    List<SparePartsOption> options,
    int? id,
  ) {
    if (id == null) return l10n.noSelection;
    return SparePartsOptions.findById(options, id)?.name ?? l10n.noSelection;
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: context.textTheme.labelMedium!.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _labeledField({
    required TextEditingController controller,
    required String label,
    Key? fieldKey,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
      validator: validator,
      style: context.textTheme.bodyMedium!.copyWith(
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.textTheme.labelSmall!.copyWith(
          color: AppColors.textSecondary(context),
        ),
        filled: true,
        fillColor: context.colorScheme.surfaceContainer,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }

  Widget _classificationRow({
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.35)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left, color: color, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _imagesSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (_images.length < _kMaxProductImages)
              Flexible(
                child: TextButton.icon(
                  onPressed: _pickImages,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  icon: Icon(Icons.add_photo_alternate_outlined, size: 18.sp),
                  label: Text(l10n.addImages, overflow: TextOverflow.ellipsis),
                ),
              ),
            const Spacer(),
            Text(
              l10n.imagesCount(_images.length, _kMaxProductImages),
              style: context.textTheme.labelSmall!.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
        if (_images.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _images
                .map(
                  (image) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(
                          File(image.path),
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => _removeImage(image),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColors.black,
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _saveBar({
    required AppLocalizations l10n,
    required bool isCreating,
    required OwnerProductsCubit cubit,
  }) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isCreating ? null : () => _submit(cubit),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isCreating
                ? SizedBox(
                    width: 22.sp,
                    height: 22.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    l10n.saveProduct,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
