// ignore_for_file: unnecessary_underscores

import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/const.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/washers/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/washers/presentation/cubit/washers/washers_cubit.dart';
import 'package:car_care/features/car_washer/washers/presentation/cubit/washers/washers_state.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washer_listing_card.dart';
import 'package:car_care/features/car_washer/washers/presentation/widgets/washers_page/washers_city_filter_bar.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WashersPage extends StatefulWidget {
  const WashersPage({super.key});

  @override
  State<WashersPage> createState() => _WashersPageState();
}

class _WashersPageState extends State<WashersPage> {
  late final TextEditingController _cityController;
  late final WashersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();

    _cubit = getIt<WashersCubit>();
    _cubit.fetchWashers();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.washersPageTitle,
          showBackButton: true,
          onBackTapped: () => context.go(Routes.home),
        ),
        body: ImageBackground(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                WashersCityFilterBar(
                  controller: _cityController,
                  onChanged: (value) {
                    _cubit.onCityChanged(value);
                  },
                  onClear: () {
                    _cityController.clear();
                    _cubit.clearCity();
                  },
                ),

                Expanded(
                  child: BlocBuilder<WashersCubit, WashersState>(
                    builder: (context, state) {
                      if (state is WashersLoading) {
                        return const Center(child: AppLoadingWidget());
                      }

                      if (state is WashersError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    minimumSize: Size(double.infinity, 52.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  onPressed: () => _cubit.fetchWashers(),
                                  child: Text(
                                    l10n.tryAgain,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is WashersLoaded) {
                        final List<WasherEntity> items = state.items;

                        if (items.isEmpty) {
                          return Center(
                            child: Text(
                              l10n.noData,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(height: 18.h),
                          itemBuilder: (context, index) {
                            final washer = items[index];
                            return WasherListingCard(
                              washer: washer,
                              onBook: (w) => context.push(
                                Routes.washerReservation,
                                extra: w,
                              ),
                              onDetails: (w) =>
                                  context.push(Routes.washerDetails, extra: w),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
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
