import 'package:car_care/core/theme/app_colors.dart';
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
    final (icon, color, title, subtitle) = switch (status) {
      ProviderApprovalStatus.pending => (
          Icons.hourglass_empty_rounded,
          Colors.orange,
          'حسابك قيد المراجعة',
          'يرجى الانتظار حتى تتم مراجعة بياناتك من قبل الإدارة.',
        ),
      ProviderApprovalStatus.rejected => (
          Icons.cancel_outlined,
          Colors.red,
          'تم رفض الحساب',
          (rejectionReason != null && rejectionReason!.isNotEmpty)
              ? 'سبب الرفض: $rejectionReason'
              : 'تم رفض طلبك. يرجى التواصل مع الإدارة لمعرفة التفاصيل.',
        ),
      ProviderApprovalStatus.suspended => (
          Icons.pause_circle_outline,
          const Color(0xFF555555),
          'تم إيقاف الحساب مؤقتًا',
          'يرجى التواصل مع الإدارة لمعرفة التفاصيل.',
        ),
    };

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
