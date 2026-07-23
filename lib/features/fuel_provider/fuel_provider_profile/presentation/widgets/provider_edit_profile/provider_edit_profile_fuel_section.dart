import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/theme/buttons/app_button_widget.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_edit_profile/provider_edit_profile_fields.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_cards.dart';
import 'package:car_care/features/fuel_provider/fuel_provider_profile/presentation/widgets/provider_profile/provider_profile_ui_model.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> showProviderFuelPriceDialog(
  BuildContext context, {
  required String fuelType,
  String? initialPrice,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) {
      return _ProviderFuelPriceSheet(
        fuelType: fuelType,
        initialPrice: initialPrice,
      );
    },
  );
}

class _ProviderFuelPriceSheet extends StatefulWidget {
  const _ProviderFuelPriceSheet({
    required this.fuelType,
    this.initialPrice,
  });

  final String fuelType;
  final String? initialPrice;

  @override
  State<_ProviderFuelPriceSheet> createState() => _ProviderFuelPriceSheetState();
}

class _ProviderFuelPriceSheetState extends State<_ProviderFuelPriceSheet> {
  late final TextEditingController _priceController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.initialPrice ?? '');
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      final text = _priceController.text;
      _priceController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: text.length,
      );
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _save() {
    final price = _priceController.text.trim();
    final l10n = context.l10n;
    if (price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.providerEditProfileSetPriceRequired)),
      );
      return;
    }
    Navigator.pop(context, price);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.providerEditProfileSetPriceTitle(widget.fuelType),
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ProviderEditProfileInputField(
              label: l10n.price,
              hint: l10n.providerEditProfileSetPriceHint,
              controller: _priceController,
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              leading: ProviderEditProfileFieldIcon(
                assetPath: AppAssets.fuelOrderMoneyIcon,
              ),
            ),
            SizedBox(height: 20.h),
            AppButton(
              onPressed: _save,
              text: l10n.save,
              backgroundColor: AppColors.orange,
              borderRadius: 28.r,
              height: 52.h,
              fontSize: 18.sp,
            ),
            SizedBox(height: 10.h),
            AppButton(
              onPressed: () => Navigator.pop(context),
              text: l10n.cancel,
              isOutline: true,
              backgroundColor: AppColors.carWashTeal,
              outlineSurfaceColor: AppColors.white,
              textColor: AppColors.carWashTeal,
              borderRadius: 28.r,
              height: 52.h,
              fontSize: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderEditProfileFuelServicesSection extends StatelessWidget {
  const ProviderEditProfileFuelServicesSection({
    super.key,
    required this.fuelPrices,
    this.onFuelTypeTap,
  });

  final Map<String, String> fuelPrices;
  final void Function(String fuelType)? onFuelTypeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fuelTypes = ProviderProfileUiModel.preview.fuelPrices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProviderProfileSectionTitle(
          title: l10n.providerProfileServicesAndPricesTitle,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            for (var i = 0; i < fuelTypes.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: _FuelServiceCard(
                  fuelType: fuelTypes[i].fuelType,
                  subtitle: _subtitleFor(
                    context,
                    fuelType: fuelTypes[i].fuelType,
                    fuelPrices: fuelPrices,
                  ),
                  onTap: () => onFuelTypeTap?.call(fuelTypes[i].fuelType),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _subtitleFor(
    BuildContext context, {
    required String fuelType,
    required Map<String, String> fuelPrices,
  }) {
    final l10n = context.l10n;
    final price = fuelPrices[fuelType];
    if (price != null && price.isNotEmpty) {
      return l10n.providerProfilePriceLine(price);
    }
    return l10n.providerEditProfileActivateServiceLine;
  }
}

class _FuelServiceCard extends StatelessWidget {
  const _FuelServiceCard({
    required this.fuelType,
    required this.subtitle,
    this.onTap,
  });

  final String fuelType;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.carWashTeal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  fuelType,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: borderColor.withValues(alpha: 0.35),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
