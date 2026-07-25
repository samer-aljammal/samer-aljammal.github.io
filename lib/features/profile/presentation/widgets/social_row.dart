import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/social_link.dart';

/// Row of square icon tiles for outbound profile links.
class SocialRow extends StatelessWidget {
  const SocialRow({required this.links, this.alignment, super.key});

  final List<SocialLink> links;
  final WrapAlignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: alignment ?? WrapAlignment.start,
      children: [
        for (final SocialLink link in links) _SocialTile(link: link),
      ],
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.link});

  final SocialLink link;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: link.label,
      child: HoverRegion(
        onTap: () => LinkLauncher.open(link.url),
        builder: (BuildContext context, bool hovered) => AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.enter,
          width: 46,
          height: 46,
          transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: hovered ? AppColors.surfaceHigh : AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: hovered ? AppColors.borderStrong : AppColors.border,
            ),
            boxShadow: hovered
                ? AppColors.glow(AppColors.violet, strength: 0.6)
                : null,
          ),
          child: Icon(
            link.icon,
            size: 19,
            color: hovered ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
