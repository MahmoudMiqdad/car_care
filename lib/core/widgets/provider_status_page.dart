import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';

enum ProviderApprovalStatus { pending, rejected, suspended }

class ProviderStatusPage extends StatelessWidget {
  const ProviderStatusPage({
    super.key,
    required this.status,
    this.rejectionReason,
  });

  final ProviderApprovalStatus status;
  final String? rejectionReason;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    final (icon, color, title, subtitle) = switch (status) {
      ProviderApprovalStatus.pending => (
        Icons.hourglass_empty_rounded,
        AppColors.warningColor(context),
        l10n.providerReviewPendingTitle,
        l10n.providerReviewPendingMessage,
      ),
      ProviderApprovalStatus.rejected => (
        Icons.cancel_outlined,
        colorScheme.error,
        l10n.providerReviewRejectedTitle,
        (rejectionReason != null && rejectionReason!.isNotEmpty)
            ? l10n.rejectionReasonPrefix(rejectionReason!)
            : l10n.providerReviewRejectedDefaultReason,
      ),
      ProviderApprovalStatus.suspended => (
        Icons.pause_circle_outline,
        colorScheme.onSurfaceVariant,
        l10n.providerReviewSuspendedTitle,
        l10n.providerReviewSuspendedMessage,
      ),
    };

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget? buildProviderStatusGate(String? status, String? rejectionReason) {
  return switch (status) {
    'pending' => ProviderStatusPage(status: ProviderApprovalStatus.pending),
    'rejected' => ProviderStatusPage(
      status: ProviderApprovalStatus.rejected,
      rejectionReason: rejectionReason,
    ),
    'suspended' => ProviderStatusPage(status: ProviderApprovalStatus.suspended),
    _ => null,
  };
}
