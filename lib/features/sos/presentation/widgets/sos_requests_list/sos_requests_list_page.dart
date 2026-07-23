import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_cubit.dart';
import 'package:car_care/features/sos/presentation/cubit/sos_cubit/sos_state.dart';
import 'package:car_care/features/sos/presentation/widgets/sos_requests_list/sos_request_card.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SosRequestsListPage extends StatelessWidget {
  const SosRequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.lightScaffold,
          appBar: CustomAppBar(
            title: l10n.sosRequestsListTitle,
            showBackButton: true,
            backgroundColor: AppColors.carWashTeal,
            onBackTapped: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(Routes.home);
              }
            },
          ),
          body: ImageBackground(
            child: BlocBuilder<SosCubit, SosState>(
              builder: (context, state) {
                if (state is SosLoading) {
                  return const Center(child: AppLoadingWidget());
                }

                if (state is SosError) {
                  return Center(child: Text(state.message));
                }

                if (state is SosListLoaded) {
                  final sosList = state.listSOs;

                  return RefreshIndicator(
                    // silent: keep the current list visible while refreshing;
                    // only the pull indicator spins.
                    onRefresh: () =>
                        context.read<SosCubit>().getAll(silent: true),
                    child: sosList.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 180.h),
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 48.r,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12.h),
                              const Center(
                                child: Text('لا توجد طلبات طوارئ حالياً'),
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              AppConstants.pageHorizontal,
                              16.h,
                              AppConstants.pageHorizontal,
                              16.h,
                            ),
                            itemCount: sosList.length,
                            separatorBuilder: (_, _) => SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              return SosRequestCard(item: sosList[index]);
                            },
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
