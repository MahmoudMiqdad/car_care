import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/requests_action_buttons.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/add_requests/requests_form_card.dart';
import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_cubit.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_state.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/parts_mode_section.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TechnicianQuotationsPage extends StatefulWidget {
  final String requestId;

  const TechnicianQuotationsPage({super.key, required this.requestId});

  @override
  State<TechnicianQuotationsPage> createState() => _PriceOfferPageState();
}

class _PriceOfferPageState extends State<TechnicianQuotationsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool partsWithinPrice = true;

  double get _cardR => RequestsFlowStyles.formCardRadius;

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateEstimatedDays(String? value) {
    final l10n = context.l10n;
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.durationRequiredError;
    final days = int.tryParse(trimmed);
    if (days == null) return l10n.invalidNumberError;
    if (days < 1 || days > 30) {
      return l10n.durationRangeError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider(
      create: (_) =>
          SubmitQuotationCubit(getIt<ITechnicianQuotationsRepository>()),
      child: BlocConsumer<SubmitQuotationCubit, SubmitQuotationState>(
        listener: (context, state) {
          if (state is SubmitQuotationSuccess) {
            if (context.canPop()) {
              context.pop(true);
            } else {
              context.go(Routes.orderdetails, extra: widget.requestId);
            }
          }

          if (state is SubmitQuotationError) {
            AppSnackBar.error(context, localizeErrorMessage(context, state.message));
          }
        },
        builder: (context, state) {
          final isLoading = state is SubmitQuotationLoading;

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground(context),
            appBar: CustomAppBar(
              title: l10n.submitQuotationButtonLabel,
              showBackButton: true,
            ),
            body: ImageBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            AppAssets.carFinanceAmico,
                            height: 180.h,
                            width: 180.w,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        RequestsFlowStyles.formTextFieldCard(
                          context: context,
                          title: l10n.price,
                          icon: Icons.payments_outlined,
                          hintText: l10n.enterExpectedPriceHint,
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 8.h),
                        PartsModeSection(
                          withinPrice: partsWithinPrice,
                          onChanged: (v) =>
                              setState(() => partsWithinPrice = v),
                        ),
                        SizedBox(height: 12.h),
                        RequestsFormCard(
                          cardRadius: _cardR,
                          title: l10n.durationInDaysLabel,
                          icon: Icons.schedule,
                          iconColor: AppColors.primary,
                          child: TextFormField(
                            
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: isRtl ? TextAlign.right : TextAlign.left,
                            style: TextStyle(fontSize: 14.sp, height: 1.2),
                            validator: _validateEstimatedDays,
                            decoration: InputDecoration(
                                  filled: false,
                              hintText: l10n.durationRangeHint,
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary(
                                  context,
                                ).withValues(alpha: 0.7),
                                fontSize: 13.sp,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        RequestsFlowStyles.formTextFieldCard(
                          context: context,
                          title: l10n.notesLabel,
                          icon: Icons.edit_note,
                          hintText: l10n.writeAdditionalNotesHint,
                          controller: _notesController,
                        ),
                        SizedBox(height: 20.h),
                        RequestsActionButtons(
                          cardRadius: _cardR,
                          layout: RequestsActionButtonsLayout.column,
                          submitLabel: isLoading
                              ? l10n.sendingRequest
                              : l10n.sendQuotationActionLabel,

                          cancelLabel: l10n.backButton,
                          onSubmit: isLoading
                              ? () {}
                              : () {
                                  if (_formKey.currentState?.validate() !=
                                      true) {
                                    return;
                                  }

                                  final estimatedDays = int.parse(
                                    _durationController.text.trim(),
                                  );

                                  final data = {
                                    "price": _priceController.text,
                                    "estimated_days": estimatedDays,
                                    "notes": _notesController.text,
                                    "parts_included": partsWithinPrice
                                        ? "1"
                                        : "0",
                                  };

                                  context
                                      .read<SubmitQuotationCubit>()
                                      .submitQuotation(data, widget.requestId);
                                },
                          onCancel: () => context.safePopOrGo(Routes.orders),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModeChip extends StatelessWidget {
  const ModeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color primary = AppColors.primary;
    final Color success = AppColors.green;
    final Color bg = selected
        ? AppColors.green.withValues(alpha: 0.12)
        : context.colorScheme.surfaceContainer;
    final Color borderColor = selected ? success : primary;
    final Color textColor = selected ? success : primary;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelMedium!.copyWith(
                color: textColor,
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
