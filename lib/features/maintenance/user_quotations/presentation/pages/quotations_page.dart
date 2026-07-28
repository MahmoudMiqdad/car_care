import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_cubit.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_state.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/widgets/quotation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class QuotationsPage extends StatefulWidget {
  const QuotationsPage({super.key, required this.requestId});

  final String requestId;

  @override
  State<QuotationsPage> createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuotationsCubit>().fetchQuotations(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: CustomAppBar(
          title: 'عروض الأسعار',
          showBackButton: true,
          backgroundColor: AppColors.carWashTeal,
          onBackTapped: () => context.safePopOrGo(Routes.all_requests),
        ),
        body: ImageBackground(
          child: BlocBuilder<QuotationsCubit, QuotationsState>(
            builder: (context, state) {
              if (state is QuotationsLoading) {
                return const Center(child: AppLoadingWidget());
              }

              if (state is QuotationsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => context
                            .read<QuotationsCubit>()
                            .fetchQuotations(widget.requestId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is QuotationsLoaded) {
                if (state.quotations.data.isEmpty) {
                  return const Center(child: Text('لا توجد عروض أسعار'));
                }

                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<QuotationsCubit>()
                      .fetchQuotations(widget.requestId),
                  child: SafeArea(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        AppConstants.pageHorizontal,
                        30.h,
                        AppConstants.pageHorizontal,
                        16.h,
                      ),
                      itemCount: state.quotations.data.length,
                      separatorBuilder: (_, _) => SizedBox(height: 16.h),
                      itemBuilder: (_, index) {
                        final quotation = state.quotations.data[index];
                        return QuotationCard(
                          quotation: quotation,
                          onTap: () {
                           context.push(
  Routes.quotation_details,
  extra: {
    'quotation': quotation,
    'requestId':widget. requestId,
  },
);
                          },
                        );
                      },
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}