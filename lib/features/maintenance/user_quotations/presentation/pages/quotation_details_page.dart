import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_cubit.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/cubit/quotations_state.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/widgets/accept_quotation_dialog.dart';
import 'package:car_care/features/maintenance/user_quotations/presentation/widgets/quotation_details_body.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuotationDetailsPage extends StatelessWidget {
  const QuotationDetailsPage({
    super.key,
    required this.quotation,
    required this.requestId,
  });

  final String requestId;
  final QuotationEntity quotation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: l10n.quotationDetailsTitle,
        showBackButton: true,
        backgroundColor: AppColors.carWashTeal,
        onBackTapped: () => context.safePopOrGo(Routes.all_requests),
      ),
      body: ImageBackground(
        child: BlocConsumer<QuotationsCubit, QuotationsState>(
          listener: (context, state) {
            if (state is QuotationAccepted) {
              AppSnackBar.success(context, l10n.quotationAcceptedSuccess);
              context.safePopOrGo(Routes.all_requests);
            }
            if (state is QuotationRejected) {
              AppSnackBar.success(context, l10n.quotationRejectedSuccess);
              context.safePopOrGo(Routes.all_requests);
            }
            if (state is QuotationsError) {
              AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is QuotationsLoading;
        
            return QuotationDetailsBody(
              quotation: quotation,
              isLoading: isLoading,
              onAccept: () async {
                final result = await showAcceptQuotationDialog(context);
                if (result == null) return;
            
                if (!context.mounted) return;
                context.read<QuotationsCubit>().acceptQuotation(
                  {
                    'scheduled_date': result.scheduledDate,
                    'notes': result.notes,
                  },
                  requestId.toString(),
                  quotation.id.toString(),
                );
              },
              onReject: (reason) {
                context.read<QuotationsCubit>().rejectQuotation(
                  reason,
                  quotation.id.toString(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
