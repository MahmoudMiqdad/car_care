import 'package:car_care/core/constants/appbox_container.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum RingCardLayout { vertical, side }

class RingIndicator {
  final String label;
  final int value;
  final IconData icon;
  final Color? color;

  const RingIndicator({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });
}

class RingCardData {
  final String title;
  final int mainValue;
  final String mainLabel;
  final double progress;

  final IconData headerIcon;
  final Color accentColor;
  final RingCardLayout layout;

  final List<RingIndicator> indicators;

  const RingCardData({
    required this.title,
    required this.mainValue,
    this.mainLabel = 'الإجمالي',
    required this.progress,
    required this.headerIcon,
    this.accentColor = AppColors.primary,
    this.layout = RingCardLayout.vertical,
    this.indicators = const [],
  });
}

class RingCard extends StatelessWidget {
  const RingCard({super.key, required this.data});

  final RingCardData data;

  @override
  Widget build(BuildContext context) {
    final p = data.progress.clamp(0.0, 1.0);

    return AppBoxContainer(
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: data.layout == RingCardLayout.side
            ? _SideLayout(data: data, progress: p)
            : _VerticalLayout(data: data, progress: p),
      ),
    );
  }
}

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({required this.data, required this.progress});

  final RingCardData data;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          title: data.title,
          icon: data.headerIcon,
          color: data.accentColor,
        ),
        SizedBox(height: 10.h),
        Center(
          child: _Ring(
            progress: progress,
            mainValue: data.mainValue,
            mainLabel: data.mainLabel,
            color: data.accentColor,
          ),
        ),
        SizedBox(height: 10.h),

        if (data.indicators.isNotEmpty) ...[
          Wrap(
            spacing: 10.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: data.indicators
                .map(
                  (e) => _IndicatorPill(indicator: e, accent: data.accentColor),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _SideLayout extends StatelessWidget {
  const _SideLayout({required this.data, required this.progress});

  final RingCardData data;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          title: data.title,
          icon: data.headerIcon,
          color: data.accentColor,
        ),
        SizedBox(height: 12.h),
        Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: _Ring(
                  progress: progress,
                  mainValue: data.mainValue,
                  mainLabel: data.mainLabel,
                  color: data.accentColor,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 7,
              child: Column(
                children: data.indicators
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _IndicatorRow(
                          indicator: e,
                          accent: data.accentColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.icon, required this.color});

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 22.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.progress,
    required this.mainValue,
    required this.mainLabel,
    required this.color,
  });

  final double progress;
  final int mainValue;
  final String mainLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bg = color.withOpacity(0.18);

    return SizedBox(
      width: 140.w,
      height: 140.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140.w,
            height: 140.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12.w,
              backgroundColor: bg,
              color: color,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$mainValue',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                mainLabel,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicatorPill extends StatelessWidget {
  const _IndicatorPill({required this.indicator, required this.accent});

  final RingIndicator indicator;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = indicator.color ?? accent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(indicator.icon, size: 18.sp, color: c),
          SizedBox(width: 8.w),
          Text(
            '${indicator.label}:',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${indicator.value}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({required this.indicator, required this.accent});

  final RingIndicator indicator;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = indicator.color ?? accent;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: c.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(indicator.icon, size: 18.sp, color: c),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            indicator.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '${indicator.value}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: c,
          ),
        ),
      ],
    );
  }
}
