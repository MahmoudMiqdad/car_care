import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianCancelResponseDialog extends StatefulWidget {
  const TechnicianCancelResponseDialog({super.key});

  @override
  State<TechnicianCancelResponseDialog> createState() =>
      _TechnicianCancelResponseDialogState();
}

class _TechnicianCancelResponseDialogState
    extends State<TechnicianCancelResponseDialog> {
  late final TextEditingController _controller;
  String? _error;

  static const int _minLength = 5;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final l10n = context.l10n;
    final reason = _controller.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = l10n.cancellationReasonRequired);
      return;
    }
    if (reason.length < _minLength) {
      setState(() => _error = l10n.cancellationReasonMinLengthError(_minLength));
      return;
    }
    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        l10n.cancelResponseTitle,
        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        minLines: 2,
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        decoration: InputDecoration(
          labelText: l10n.cancelResponseLabel,
          hintText: l10n.cancelResponseHint,
          errorText: _error,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          contentPadding: EdgeInsets.all(10.w),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.backButton,
            style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14.sp),
          ),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: Text(
            l10n.confirmCancellationButton,
            style: TextStyle(
              color: AppColors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

Future<String?> showTechnicianCancelResponseDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const TechnicianCancelResponseDialog(),
  );
}
