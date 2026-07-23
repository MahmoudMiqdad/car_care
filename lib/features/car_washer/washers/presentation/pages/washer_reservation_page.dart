import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/app_typography.dart';
import 'package:car_care/core/widgets/app_date_time_picker_row.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/domain/entities/washers_entity.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/reservation/car_wash_booking_cubit.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/cubit/reservation/car_wash_booking_state.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_action_buttons_row.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_header_info.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_inline_input_card.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_service_tier_card.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/reservation/reservation_tier_pricing.dart';
import 'package:car_care/features/car_washer/car_wash/washers_browse/presentation/widgets/washer_service_tier.dart';

import 'package:car_care/l10n.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

class WasherReservationPage extends StatefulWidget {
  const WasherReservationPage({super.key, required this.washer});

  final WasherEntity washer;

  @override
  State<WasherReservationPage> createState() => _WasherReservationPageState();
}

class _WasherReservationPageState extends State<WasherReservationPage> {
  DateTime? _date;
  TimeOfDay? _time;
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late WasherServiceTier _selectedTier;

  @override
  void initState() {
    super.initState();
    final options = reservationTiersToShow(widget.washer);
    _selectedTier = options.contains(WasherServiceTier.vip)
        ? WasherServiceTier.vip
        : options.first;
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _dateLabel(BuildContext context) {
    final d = _date;
    if (d == null) return context.l10n.washerReservationPickDate;
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(d);
  }

  String _timeLabel(BuildContext context) {
    final t = _time;
    if (t == null) return context.l10n.washerReservationPickTime;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String _tierTitle(AppLocalizations l10n, WasherServiceTier t) {
    return switch (t) {
      WasherServiceTier.premium => l10n.washerReservationServicePremium,
      WasherServiceTier.vip => l10n.washerReservationServiceVip,
      WasherServiceTier.basic => l10n.washerReservationServiceBasic,
    };
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _onConfirm(BuildContext ctx) {
    final vehicleIdRaw = _vehicleController.text.trim();
    final vehicleId = int.tryParse(vehicleIdRaw);

    if (_date == null || _time == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار التاريخ والوقت')),
      );
      return;
    }
    if (vehicleId == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم المركبة')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );
    final scheduledAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduledDateTime);

    ctx.read<CarWashBookingCubit>().createBooking(
          vehicleId: vehicleId,
          carWasherId: widget.washer.id,
          scheduledAt: scheduledAt,
          serviceType: _selectedTier.name,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final washer = widget.washer;
    final tiers = reservationTiersToShow(washer);

    return BlocProvider(
      create: (_) => getIt<CarWashBookingCubit>(),
      child: BlocConsumer<CarWashBookingCubit, CarWashBookingState>(
        listener: (ctx, state) {
          if (state is CarWashBookingSuccess) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: const Text('تم الحجز بنجاح'),
                backgroundColor: Colors.green.shade600,
              ),
            );
            ctx.go(Routes.bookings);
          } else if (state is CarWashBookingError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is CarWashBookingSubmitting;
          return Scaffold(
            appBar: CustomAppBar(
              title: l10n.washerReservationTitle,
              showBackButton: true,
              onBackTapped: () => context.safePopOrGo(Routes.washers),
              backgroundColor: AppColors.carWashTeal,
            ),
            body: ImageBackground(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ReservationHeaderInfo(washer: washer),
                    SizedBox(height: 10.h),
                    AppDateTimePickerRow(
                      dateText: _dateLabel(context),
                      timeText: _timeLabel(context),
                      onDateTap: _pickDate,
                      onTimeTap: _pickTime,
                    ),
                    SizedBox(height: 10.h),
                    ReservationInlineInputCard(
                      leading: Image.asset(
                        'assets/images/icons8-car-50.png',
                        width: 22.w,
                        height: 22.w,
                        fit: BoxFit.contain,
                      ),
                      label: l10n.washerReservationFieldVehicleLabel,
                      controller: _vehicleController,
                      hintText: l10n.washerReservationFieldVehicleHint,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 14.h),
                    ReservationInlineInputCard(
                      leading: Icon(
                        IconsaxPlusLinear.document_text_1,
                        size: 20.sp,
                        color: AppColors.carWashTeal,
                      ),
                      label: l10n.washerReservationFieldNotesLabel,
                      controller: _notesController,
                      hintText: l10n.washerReservationFieldNotesHint,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 2,
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      l10n.washerReservationChooseService,
                      textAlign: TextAlign.right,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 19.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: <Widget>[
                        for (int i = 0; i < tiers.length; i++) ...<Widget>[
                          if (i > 0) SizedBox(width: 8.w),
                          ReservationServiceTierCard(
                            title: _tierTitle(l10n, tiers[i]),
                            priceAmount: reservationTierPriceUsd(washer, tiers[i]),
                            isSelected: _selectedTier == tiers[i],
                            onTap: isLoading ? () {} : () => setState(() => _selectedTier = tiers[i]),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 20.h),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ReservationActionButtonsRow(
                        confirmText: l10n.washerReservationConfirm,
                        cancelText: l10n.washerReservationCancel,
                        onConfirm: () => _onConfirm(ctx),
                        onCancel: () => context.safePopOrGo(Routes.washers),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
