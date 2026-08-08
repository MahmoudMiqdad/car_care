import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/car_wash/bookings/domain/entities/bookings_entity.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/cubit/ratings_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/cubit/ratings_state.dart';
import 'package:car_care/features/car_washer/car_wash/ratings/presentation/widgets/ratings_page/ratings_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key, required this.booking});

  final BookingsEntity booking;

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  int _selectedStars = 3;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return BlocProvider(
      create: (_) => getIt<RatingsCubit>(),
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.lightScaffold,
              appBar: CustomAppBar(
                title: strings.rateService,
                showBackButton: true,
              ),
              body: ImageBackground(
                child: BlocConsumer<RatingsCubit, RatingsState>(
                  listener: (context, state) {
                    if (state is RatingsSuccess) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      context.safePopOrGo(Routes.bookings, result: true);
                    }

                    if (state is RatingsError) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                          ),
                        );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is RatingsLoading;

                    return RatingsBody(
                      booking: widget.booking,
                      selectedStars: _selectedStars,
                      isLoading: isLoading,
                      onStarsChanged: (value) {
                        setState(() => _selectedStars = value);
                      },
                      onSubmit: isLoading
                          ? null
                          : () {
                              context.read<RatingsCubit>().submitRating(
                                bookingId: widget.booking.id,
                                rating: _selectedStars,
                                review: '',
                              );
                            },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
