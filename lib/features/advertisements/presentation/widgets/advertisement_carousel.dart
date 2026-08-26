import 'dart:async';

import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_card.dart';
import 'package:car_care/features/advertisements/presentation/widgets/advertisement_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvertisementCarousel extends StatefulWidget {
  const AdvertisementCarousel({
    super.key,
    required this.advertisements,
    required this.height,
    this.borderRadius = 16,
    this.imageFit = BoxFit.cover,
  });

  final List<AdvertisementEntity> advertisements;
  final double height;
  final double borderRadius;
  final BoxFit imageFit;

  @override
  State<AdvertisementCarousel> createState() => _AdvertisementCarouselState();
}

class _AdvertisementCarouselState extends State<AdvertisementCarousel> {
  static const _autoAdvanceDelay = Duration(seconds: 4);
  static const _autoAdvanceAnimation = Duration(milliseconds: 450);

  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _armAutoAdvance();
  }

  @override
  void didUpdateWidget(covariant AdvertisementCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.advertisements.length != oldWidget.advertisements.length) {
      if (_currentIndex >= widget.advertisements.length) {
        _currentIndex = 0;
      }
      _armAutoAdvance();
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _armAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    final count = widget.advertisements.length;
    if (count < 2) return;

    _autoAdvanceTimer = Timer(_autoAdvanceDelay, () {
      if (!mounted || !_controller.hasClients) return;
      final nextIndex = (_currentIndex + 1) % count;
      _controller.animateToPage(
        nextIndex,
        duration: _autoAdvanceAnimation,
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _armAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    final ads = widget.advertisements;
    final isSingle = ads.length == 1;

    return Column(
      children: [
        SizedBox(
          height: widget.height.h,
          child: isSingle
              ? AdvertisementCard(
                  advertisement: ads.first,
                  height: widget.height,
                  borderRadius: widget.borderRadius,
                  imageFit: widget.imageFit,
                )
              : PageView.builder(
                  controller: _controller,
                  itemCount: ads.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) => AdvertisementCard(
                    advertisement: ads[index],
                    height: widget.height,
                    borderRadius: widget.borderRadius,
                    imageFit: widget.imageFit,
                  ),
                ),
        ),
        if (!isSingle) ...[
          SizedBox(height: 8.h),
          AdvertisementDotIndicator(
            count: ads.length,
            currentIndex: _currentIndex,
          ),
        ],
      ],
    );
  }
}
