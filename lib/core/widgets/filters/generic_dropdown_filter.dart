import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericDropdownFilter<T> extends StatelessWidget {
  const GenericDropdownFilter({
    super.key,
    required this.options,
    required this.labelBuilder,
    required this.selectedValue,
    required this.onChanged,
    required this.triggerLabel,
    this.icon = Icons.keyboard_arrow_down_rounded,
    this.maxListHeightFraction = 0.55,
    this.rtl = true,
  });

  final List<T> options;

  final String Function(T option) labelBuilder;

  final T? selectedValue;

  final ValueChanged<T> onChanged;

  final String triggerLabel;

  final IconData icon;

  final double maxListHeightFraction;

  final bool rtl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => _openOptions(context),
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary, width: 1.3),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Icon(icon, color: context.colorScheme.onSurface),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                triggerLabel,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openOptions(BuildContext context) async {
    final media = MediaQuery.of(context);
    final rawSafeHeight =
        media.size.height - media.padding.top - media.padding.bottom;
    final safeHeight = rawSafeHeight > 0 ? rawSafeHeight : media.size.height;
    final maxHeight = safeHeight * maxListHeightFraction;
    final selectedIndex = selectedValue == null
        ? -1
        : options.indexOf(selectedValue as T);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final content = _GenericFilterSheet<T>(
          options: options,
          labelBuilder: labelBuilder,
          selectedIndex: selectedIndex,
          maxHeight: maxHeight,
          onSelected: (option) {
            Navigator.of(sheetContext).pop();
            onChanged(option);
          },
        );
        return rtl
            ? Directionality(textDirection: TextDirection.rtl, child: content)
            : content;
      },
    );
  }
}

class _GenericFilterSheet<T> extends StatefulWidget {
  const _GenericFilterSheet({
    required this.options,
    required this.labelBuilder,
    required this.selectedIndex,
    required this.maxHeight,
    required this.onSelected,
  });

  final List<T> options;
  final String Function(T option) labelBuilder;
  final int selectedIndex;
  final double maxHeight;
  final ValueChanged<T> onSelected;

  static const double _itemExtent = 48;

  @override
  State<_GenericFilterSheet<T>> createState() => _GenericFilterSheetState<T>();
}

class _GenericFilterSheetState<T> extends State<_GenericFilterSheet<T>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    if (widget.selectedIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_controller.hasClients) return;
        final target = widget.selectedIndex * _GenericFilterSheet._itemExtent.h;
        _controller.jumpTo(
          target.clamp(0.0, _controller.position.maxScrollExtent),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                thickness: 4,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  itemCount: widget.options.length,
                  itemExtent: _GenericFilterSheet._itemExtent.h,
                  itemBuilder: (context, index) {
                    final option = widget.options[index];
                    final isSelected = index == widget.selectedIndex;
                    return InkWell(
                      onTap: () => widget.onSelected(option),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.labelBuilder(option),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : context.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
