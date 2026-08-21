import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteJobDialog extends StatefulWidget {
  const CompleteJobDialog({super.key});

  @override
  State<CompleteJobDialog> createState() => _CompleteJobDialogState();
}

class _CompleteJobDialogState extends State<CompleteJobDialog> {
  late final TextEditingController _controller;
  String? _error;

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
    final notes = _controller.text.trim();
    if (notes.isEmpty) {
      setState(() => _error = context.l10n.completionNotesRequiredError);
      return;
    }
    Navigator.of(context).pop(notes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        l10n.completeJobTitle,
        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        minLines: 2,
        maxLength: 1000,
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        decoration: InputDecoration(
          labelText: l10n.completionNotesLabel,
          hintText: l10n.completionNotesHint,
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
            l10n.confirmCompletionButton,
            style: TextStyle(
              color: AppColors.carWashTeal,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

Future<String?> showCompleteJobDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const CompleteJobDialog(),
  );
}
