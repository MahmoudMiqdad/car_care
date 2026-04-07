
// import 'package:car_care/core/constants/app_assets.dart';
// import 'package:car_care/core/routing/routes.dart';
// import 'package:car_care/core/service_locator/service_locator.dart';
// import 'package:car_care/core/theme/app_colors.dart';
// import 'package:car_care/core/theme/app_typography.dart';
// import 'package:car_care/core/widgets/const.dart';
// import 'package:car_care/core/widgets/image_background.dart';
// import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
// import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_action_buttons.dart';
// import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
// import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_cubit.dart';
// import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_state.dart';

// import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/parts_mode_section.dart';
// import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class TechnicianQuotationsPage extends StatefulWidget {
//   final String requestId;

//   const TechnicianQuotationsPage({super.key, required this.requestId});

//   @override
//   State<TechnicianQuotationsPage> createState() => _PriceOfferPageState();
// }

// class _PriceOfferPageState extends State<TechnicianQuotationsPage> {
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();

//   bool partsWithinPrice = true;

//   double get _cardR => RequestsFlowStyles.formCardRadius;

//   @override
//   void dispose() {
//     _priceController.dispose();
//     _durationController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           SubmitQuotationCubit(getIt<ITechnicianQuotationsRepository>()),
//       child: BlocConsumer<SubmitQuotationCubit, SubmitQuotationState>(
//         listener: (context, state) {
//           if (state is SubmitQuotationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("تم إرسال العرض بنجاح"),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }

//           if (state is SubmitQuotationError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is SubmitQuotationLoading;

//           return Directionality(
//             textDirection: TextDirection.rtl,
//             child: Scaffold(
//               backgroundColor: AppColors.lightScaffold,
//               appBar: const CustomAppBar(
//                 title: 'تقديم عرض سعر',
//                 showBackButton: true,
//               ),
//               bottomNavigationBar: HomeBottomNavBar(
//                 activeIndex: -1,
//                 onItemSelected: (index) {
//                   if (index == 0) context.go(Routes.home);
//                 },
//               ),
//               body: ImageBackground(
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Center(
//                         child: Image.asset(
//                           AppAssets.carFinanceAmico,
//                           height: 180.h,
//                           width: 180.w,
//                         ),
//                       ),

//                       SizedBox(height: 10.h),

//                       RequestsFlowStyles.formTextFieldCard(
//                         title: 'السعر',
//                         icon: Icons.payments_outlined,
//                         hintText: 'يرجى كتابة السعر المتوقع...',
//                         controller: _priceController,
//                         keyboardType: TextInputType.number,
//                       ),

//                       SizedBox(height: 8.h),

//                       PartsModeSection(
//                         withinPrice: partsWithinPrice,
//                         onChanged: (v) => setState(() => partsWithinPrice = v),
//                       ),

//                       SizedBox(height: 12.h),

//                       RequestsFlowStyles.formTextFieldCard(
//                         title: 'المدة',
//                         keyboardType: TextInputType.number,
//                         icon: Icons.schedule,
//                         hintText: 'يرجى كتابة المدة المتوقعة...',
//                         controller: _durationController,
//                       ),

//                       SizedBox(height: 8.h),

//                       RequestsFlowStyles.formTextFieldCard(
//                         title: 'ملاحظات',
//                         icon: Icons.edit_note,
//                         hintText: 'كتابة أي ملاحظات إضافية...',
//                         controller: _notesController,
//                       ),

//                       SizedBox(height: 20.h),

//                       RequestsActionButtons(
//                         cardRadius: _cardR,
//                         layout: RequestsActionButtonsLayout.column,
//                         submitLabel: isLoading
//                             ? 'جارٍ الإرسال...'
//                             : 'إرسال العرض',
//                         cancelLabel: 'إلغاء',
//                         cancelOutlineSurfaceColor: AppColors.white,
//                         cancelTextColor: AppColors.primary,
//                         onSubmit: isLoading
//                             ? () {}
//                             : () {
//                                 final data = {
//                                   "price": _priceController.text,
//                                   "estimated_days": _durationController.text,
//                                   "notes": _notesController.text,
//                                   "parts_included": partsWithinPrice
//                                       ? "1"
//                                       : "0",
//                                 };

//                                 context
//                                     .read<SubmitQuotationCubit>()
//                                     .submitQuotation(data, widget.requestId);
//                               },
//                         onCancel: () => context.pop(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:car_care/core/constants/app_assets.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:car_care/features/maintenance/user_requests/presentation/widgets/requests_action_buttons.dart';
import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_cubit.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_state.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/parts_mode_section.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/widgets/price_offer_page/requests_flow_shared.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SubmitQuotationCubit(getIt<ITechnicianQuotationsRepository>()),
      child: BlocConsumer<SubmitQuotationCubit, SubmitQuotationState>(
        listener: (context, state) {
          if (state is SubmitQuotationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم إرسال العرض بنجاح"),
                backgroundColor: Colors.green,
              ),
            );

       
          }

          if (state is SubmitQuotationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SubmitQuotationLoading;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.lightScaffold,
              appBar: const CustomAppBar(
                title: 'تقديم عرض سعر',
                showBackButton: true,
              ),
              bottomNavigationBar: HomeBottomNavBar(
                activeIndex: -1,
                onItemSelected: (index) {
                  if (index == 0) context.go(Routes.home);
                },
              ),
              body: ImageBackground(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// صورة
                      Center(
                        child: Image.asset(
                          AppAssets.carFinanceAmico,
                          height: 180.h,
                          width: 180.w,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// السعر
                      RequestsFlowStyles.formTextFieldCard(
                        title: 'السعر',
                        icon: Icons.payments_outlined,
                        hintText: 'يرجى كتابة السعر المتوقع...',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 8.h),

                      /// قطع
                      PartsModeSection(
                        withinPrice: partsWithinPrice,
                        onChanged: (v) =>
                            setState(() => partsWithinPrice = v),
                      ),

                      SizedBox(height: 12.h),

                      /// المدة
                      RequestsFlowStyles.formTextFieldCard(
                        title: 'المدة',
                        keyboardType: TextInputType.number,
                        icon: Icons.schedule,
                        hintText: 'يرجى كتابة المدة المتوقعة...',
                        controller: _durationController,
                      ),

                      SizedBox(height: 8.h),

                      /// ملاحظات
                      RequestsFlowStyles.formTextFieldCard(
                        title: 'ملاحظات',
                        icon: Icons.edit_note,
                        hintText: 'كتابة أي ملاحظات إضافية...',
                        controller: _notesController,
                      ),

                      SizedBox(height: 20.h),

                      /// 🔥 زر الإرسال فقط
                      RequestsActionButtons(
                        cardRadius: _cardR,
                        layout: RequestsActionButtonsLayout.column,
                        submitLabel: isLoading
                            ? 'جارٍ الإرسال...'
                            : 'إرسال العرض',
                        onSubmit: isLoading
                            ? () {}
                            : () {
                                final data = {
                                  "price": _priceController.text,
                                  "estimated_days":
                                      _durationController.text,
                                  "notes": _notesController.text,
                                  "parts_included":
                                      partsWithinPrice ? "1" : "0",
                                };

                                context
                                    .read<SubmitQuotationCubit>()
                                    .submitQuotation(
                                      data,
                                      widget.requestId,
                                    );
                                    
                              },
                               onCancel: () => context.pop(),
                      ),
                    ],
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
    final Color success = AppColors.success;
    final Color bg = selected ? const Color(0xFFE8F5E9) : AppColors.white;
    final Color borderColor = selected ? success : primary;
    final Color textColor = selected ? success : primary;

    return Material(
      color: Colors.transparent,
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
              style: AppTypography.labelMedium.copyWith(
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