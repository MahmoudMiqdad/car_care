// ignore_for_file: unnecessary_underscores

import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/widgets/Empty_state.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/error_state_widget.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/washers/washers_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/washers/washers_state.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washers_page/washer_listing_card.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washers_page/washers_governorate_filter.dart';
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
  late final WashersCubit _cubit;
  String? _selectedGovernorate;

  @override
  void initState() {
    super.initState();

    _cubit = getIt<WashersCubit>();
    _cubit.fetchWashers();
  }

  @override
  void dispose() {
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
          actionWidget: TextButton(
            onPressed: () => context.push(Routes.bookings),
            child: Text(
              l10n.bookingsPageTitle,
              style: TextStyle(
                color: context.colorScheme.onPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: ImageBackground(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: WashersGovernorateFilter(
                    selectedGovernorate: _selectedGovernorate,
                    onChanged: (value) {
                      setState(() => _selectedGovernorate = value);
                      if (value == null) {
                        _cubit.clearCity();
                      } else {
                        _cubit.fetchWashers(city: value);
                      }
                    },
                  ),
                ),

                Expanded(
                  child: BlocBuilder<WashersCubit, WashersState>(
                    builder: (context, state) {
                      if (state is WashersLoading) {
                        return const Center(child: AppLoadingWidget());
                      }

                      if (state is WashersError) {
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () => _cubit.fetchWashers(),
                        );
                      }

                      if (state is WashersLoaded) {
                        final List<WasherEntity> items = state.items;

                        if (items.isEmpty) {
                          return const EmptyStateWidget();
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
