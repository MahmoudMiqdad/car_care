import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_care/core/extensions/theme_extension.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/features/advertisements/domain/entities/advertisement_entity.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementCard extends StatelessWidget {
  const AdvertisementCard({
    super.key,
    required this.advertisement,
    required this.height,
    this.borderRadius = 16,
    this.imageFit = BoxFit.cover,
  });

  final AdvertisementEntity advertisement;
  final double height;
  final double borderRadius;
  final BoxFit imageFit;

  bool get _hasValidLink {
    final url = advertisement.linkUrl;
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final scheme = uri.scheme.toLowerCase();
    return (scheme == 'http' || scheme == 'https') && uri.host.isNotEmpty;
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(advertisement.linkUrl!);
    final l10n = context.l10n;
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      AppSnackBar.error(context, l10n.advertisementLinkOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = advertisement.title;
    final hasTitle = title != null && title.isNotEmpty;
    final tappable = _hasValidLink;
    final radius = BorderRadius.circular(borderRadius.r);

    final semanticLabel = hasTitle
        ? l10n.advertisementSemanticLabelWithTitle(title)
        : l10n.advertisementSemanticLabel;
    final scaledHeight = height.h;

    final content = ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: scaledHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: advertisement.imageUrl,
              width: double.infinity,
              height: scaledHeight,
              fit: imageFit,
              placeholder: (context, url) => ColoredBox(
                color: context.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => ColoredBox(
                color: AppColors.cardBackground(context),
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textSecondary(context),
                  size: 26.sp,
                ),
              ),
            ),
            if (hasTitle)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.w, 22.h, 12.w, 10.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.transparent, AppColors.black],
                    ),
                  ),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return Semantics(
      label: semanticLabel,
      button: tappable,
      image: true,
      excludeSemantics: true,
      child: tappable
          ? Material(
              color: AppColors.transparent,
              borderRadius: radius,
              child: InkWell(
                borderRadius: radius,
                onTap: () => _open(context),
                child: content,
              ),
            )
          : content,
    );
  }
}
