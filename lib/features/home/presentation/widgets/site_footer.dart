import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../../profile/domain/entities/social_link.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    required this.name,
    required this.links,
    required this.onBackToTop,
    super.key,
  });

  final String name;

  /// Rendered as spelled-out text links rather than icon tiles. The icons in
  /// the hero and contact section are recognisable but not readable — here the
  /// full handle is visible, which is what someone scanning the bottom of the
  /// page for a profile actually wants.
  final List<SocialLink> links;

  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    final String year = DateTime.now().year.toString();

    final Widget credit = Text(
      '© $year $name — built with Flutter',
      style: AppTypography.mono(fontSize: 11, color: AppColors.textTertiary),
    );

    final Widget linkRow = Wrap(
      spacing: 22,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final SocialLink link in links) _FooterLink(link: link),
      ],
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          // Fills the available width so Wrap's spaceBetween has room to
          // distribute against; a shrink-wrapped Wrap would ignore it.
          child: SizedBox(
            width: double.infinity,
            child: context.isMobile
                ? Column(
                    children: [
                      linkRow,
                      const SizedBox(height: 20),
                      credit,
                      const SizedBox(height: 18),
                      _BackToTop(onTap: onBackToTop),
                    ],
                  )
                // Wrap rather than Row: three fixed-width items in a Row
                // overflow as soon as the viewport narrows or the name gets
                // longer. This spreads them on one line when they fit and drops
                // to a second line when they don't.
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 32,
                    runSpacing: 16,
                    children: [
                      credit,
                      linkRow,
                      _BackToTop(onTap: onBackToTop),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Spelled-out link, e.g. "github.com/samer-aljammal".
class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.link});

  final SocialLink link;

  /// Strips the scheme so the label reads as text rather than a raw URL.
  String get _label {
    final String url = link.url;
    if (url.startsWith('mailto:')) return url.substring(7);
    return url.replaceFirst(RegExp(r'^https?://(www\.)?'), '');
  }

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: () => LinkLauncher.open(link.url),
      builder: (BuildContext context, bool hovered) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                link.icon,
                size: 13,
                color: hovered ? AppColors.magenta : AppColors.textTertiary,
              ),
              const SizedBox(width: 7),
              Text(
                _label,
                style: AppTypography.mono(
                  fontSize: 11,
                  color: hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          AnimatedScale(
            scale: hovered ? 1 : 0,
            alignment: Alignment.center,
            duration: AppMotion.fast,
            curve: AppMotion.enter,
            child: Container(
              height: 1,
              width: 20 + _label.length * 6.2,
              decoration: const BoxDecoration(gradient: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackToTop extends StatelessWidget {
  const _BackToTop({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Back to top',
            style: AppTypography.mono(
              fontSize: 11,
              color: hovered ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSlide(
            offset: Offset(0, hovered ? -0.25 : 0),
            duration: AppMotion.fast,
            child: Icon(
              Icons.arrow_upward_rounded,
              size: 14,
              color: hovered ? AppColors.magenta : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
