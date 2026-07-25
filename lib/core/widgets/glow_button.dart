import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import 'hover_region.dart';

enum GlowButtonVariant {
  /// Gradient fill. One per screen — this is the primary call to action.
  solid,

  /// Bordered and transparent, for everything secondary.
  ghost,
}

class GlowButton extends StatelessWidget {
  const GlowButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = GlowButtonVariant.solid,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final GlowButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final bool solid = variant == GlowButtonVariant.solid;

    return HoverRegion(
      onTap: onPressed,
      builder: (BuildContext context, bool hovered) => AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.enter,
        transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          gradient: solid ? AppColors.accent : null,
          color: solid
              ? null
              : (hovered ? AppColors.surfaceHigh : Colors.transparent),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: solid
                ? Colors.transparent
                : (hovered ? AppColors.borderStrong : AppColors.border),
          ),
          boxShadow: switch ((solid, hovered)) {
            (true, true) => AppColors.glow(AppColors.magenta, strength: 1.4),
            (true, false) => AppColors.glow(AppColors.violet, strength: 0.7),
            (false, true) => AppColors.glow(AppColors.violet, strength: 0.4),
            (false, false) => null,
          },
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: solid ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (icon case final IconData icon) ...[
              const SizedBox(width: 10),
              // Nudges forward on hover, hinting at the navigation it triggers.
              AnimatedSlide(
                offset: Offset(hovered ? 0.25 : 0, 0),
                duration: AppMotion.fast,
                curve: AppMotion.enter,
                child: Icon(
                  icon,
                  size: 17,
                  color: solid ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
