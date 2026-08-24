import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/spare_parts_store/customer/cart/presentation/cubit/cart/cart_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/cubit/create_order/create_order_cubit.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/cubit/create_order/create_order_state.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/widgets/checkout_address_note_field.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/widgets/checkout_location_card.dart';
import 'package:car_care/features/spare_parts_store/customer/checkout/presentation/widgets/checkout_location_picker_sheet.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.totalPrice, this.cartCubit});

  final double totalPrice;
  final CartCubit? cartCubit;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CreateOrderCubit _cubit;
  late final TextEditingController _addressNoteController;
  LatLng? _selectedLocation;

  bool _s0 = false, _s1 = false, _s2 = false, _s3 = false;

  bool get _canSubmit =>
      _selectedLocation != null &&
      _addressNoteController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateOrderCubit>();
    _addressNoteController = TextEditingController();
    _addressNoteController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 60), () {
        if (mounted) setState(() => _s0 = true);
      });
      Future.delayed(const Duration(milliseconds: 160), () {
        if (mounted) setState(() => _s1 = true);
      });
      Future.delayed(const Duration(milliseconds: 260), () {
        if (mounted) setState(() => _s2 = true);
      });
      Future.delayed(const Duration(milliseconds: 340), () {
        if (mounted) setState(() => _s3 = true);
      });
    });
  }

  @override
  void dispose() {
    _cubit.close();
    _addressNoteController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final picked = await CheckoutLocationPickerSheet.show(
      context,
      initialLocation: _selectedLocation,
    );
    if (picked != null) setState(() => _selectedLocation = picked);
  }

  void _submit() {
    if (!_canSubmit) return;
    _cubit.createOrder(
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      addressNote: _addressNoteController.text.trim(),
    );
  }

  Widget _fadeSlide({
    required bool visible,
    required Widget child,
    int ms = 380,
  }) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: ms),
      curve: Curves.easeOut,
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOut,
        offset: visible ? Offset.zero : const Offset(0, 0.08),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: CustomAppBar(title: l10n.confirmOrderTitle),
        body: ImageBackground(
          child: BlocConsumer<CreateOrderCubit, CreateOrderState>(
            listener: (context, state) {
              if (state is CreateOrderSuccess) {
                AppSnackBar.success(context, l10n.orderCreatedSuccessfully);
                widget.cartCubit?.fetchCart();
                context.pushReplacement(
                  Routes.customerOrderDetailsPath(state.order.id),
                );
              }
              if (state is CreateOrderError) {
                AppSnackBar.error(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is CreateOrderLoading;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fadeSlide(
                      visible: _s0,
                      child: CheckoutLocationCard(
                        selectedLocation: _selectedLocation,
                        onPickLocation: isLoading ? () {} : _openMapPicker,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _fadeSlide(
                      visible: _s1,
                      child: CheckoutAddressNoteField(
                        controller: _addressNoteController,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _fadeSlide(
                      visible: _s2,
                      child: _OrderSummaryRow(totalPrice: widget.totalPrice),
                    ),
                    SizedBox(height: 20.h),
                    _fadeSlide(
                      visible: _s3,
                      child: _SubmitButton(
                        canSubmit: _canSubmit && !isLoading,
                        isLoading: isLoading,
                        selectedLocation: _selectedLocation,
                        hasNote: _addressNoteController.text.trim().isNotEmpty,
                        onTap: _submit,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  const _OrderSummaryRow({required this.totalPrice});

  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                l10n.orderTotalLabel,
                style: context.textTheme.labelLarge!.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Text(
            '${totalPrice.toStringAsFixed(0)} ${l10n.currencySyp}',
            style: context.textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.canSubmit,
    required this.isLoading,
    required this.selectedLocation,
    required this.hasNote,
    required this.onTap,
  });

  final bool canSubmit;
  final bool isLoading;
  final LatLng? selectedLocation;
  final bool hasNote;
  final VoidCallback onTap;

  String? _validationMessage(BuildContext context) {
    final l10n = context.l10n;
    if (selectedLocation == null) return l10n.pleaseSelectDeliveryLocation;
    if (!hasNote) return l10n.pleaseEnterAddressNote;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final msg = _validationMessage(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (msg != null) ...[
          Row(
            children: [
              Icon(Icons.info_outline, size: 14.sp, color: AppColors.warning),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  msg,
                  style: context.textTheme.labelSmall!.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: canSubmit ? 1 : 0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          builder: (context, t, _) {
            final bgColor = Color.lerp(
              AppColors.border(context),
              AppColors.accent,
              t,
            )!;
            return ElevatedButton(
              onPressed: canSubmit ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: AppColors.white,
                disabledForegroundColor: AppColors.white.withOpacity(0.6),
                disabledBackgroundColor: bgColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        key: const ValueKey('text'),
                        l10n.confirmOrderButton,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
