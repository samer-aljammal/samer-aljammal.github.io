import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/widgets/underline_link.dart';
import '../../../profile/domain/entities/social_link.dart';

/// Minimal footer: hairline rule, spelled-out links, credit, back to top.
class SiteFooter extends StatelessWidget {
  const SiteFooter({
    required this.name,
    required this.links,
    required this.onBackToTop,
    super.key,
  });

  final String name;
  final List<SocialLink> links;
  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    final String year = DateTime.now().year.toString();

    final Widget credit = Text(
      'Â© $year $name',
      style: AppTypography.sans(fontSize: 11, color: AppColors.fog),
    );

    // Handles spelled out, not icons: the bottom of a page is where someone
    // looks for an address they can read and copy.
    final Widget linkRow = Wrap(
      spacing: 28,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        for (final SocialLink link in links)
          UnderlineLink(
            label: link.url.startsWith('mailto:')
                ? link.url.substring(7)
                : link.url.replaceFirst(RegExp(r'^https?://(www\.)?'), ''),
            color: AppColors.fog,
            style: AppTypography.sans(fontSize: 11, color: AppColors.fog),
            onTap: () => LinkLauncher.open(link.url),
          ),
      ],
    );

    final Widget backToTop = UnderlineLink(
      label: 'Back to top',
      icon: Icons.arrow_upward,
      color: AppColors.fog,
      style: AppTypography.sans(fontSize: 11, color: AppColors.fog),
      onTap: onBackToTop,
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.ashBorder)),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: SizedBox(
            width: double.infinity,
            child: context.isMobile
                ? Column(
                    children: [
                      linkRow,
                      const SizedBox(height: 24),
                      credit,
                      const SizedBox(height: 20),
                      backToTop,
                    ],
                  )
                // Wrap, not Row: three fixed-width items overflow as soon as
                // the viewport narrows or the name gets longer.
                : Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 32,
                    runSpacing: 16,
                    children: [credit, linkRow, backToTop],
                  ),
          ),
        ),
      ),
    );
  }
}
