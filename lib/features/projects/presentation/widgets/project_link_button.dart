import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/widgets/hover_region.dart';

/// Compact text link with an underline that wipes in on hover.
class ProjectLinkButton extends StatelessWidget {
  const ProjectLinkButton({
    required this.label,
    required this.url,
    required this.icon,
    super.key,
  });

  final String label;
  final String url;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: () => LinkLauncher.open(url),
      builder: (BuildContext context, bool hovered) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: hovered ? AppColors.magenta : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Grows from the left rather than fading, so the direction of the
          // gesture matches the reading direction.
          AnimatedScale(
            scale: hovered ? 1 : 0,
            alignment: Alignment.centerLeft,
            duration: AppMotion.fast,
            curve: AppMotion.enter,
            child: Container(
              height: 1.5,
              width: 20 + label.length * 7.5,
              decoration: const BoxDecoration(gradient: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
