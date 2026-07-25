import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import 'hover_region.dart';

/// The standard raised panel: tinted surface, hairline border, top-lit sheen.
///
/// When [interactive] is true it lifts and picks up an accent glow on hover, so
/// cards, tags and link tiles all respond identically.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 20,
    this.interactive = false,
    this.onTap,
    this.glowColor = AppColors.violet,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool interactive;
  final VoidCallback? onTap;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    if (!interactive && onTap == null) return _build(context, false);
    return HoverRegion(
      onTap: onTap,
      builder: _build,
    );
  }

  Widget _build(BuildContext context, bool hovered) {
    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.enter,
      transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
      transformAlignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
        color: hovered ? AppColors.surfaceHigh : AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: hovered ? AppColors.borderStrong : AppColors.border,
        ),
        gradient: hovered ? null : AppColors.cardSheen,
        boxShadow: hovered ? AppColors.glow(glowColor, strength: 0.8) : null,
      ),
      child: child,
    );
  }
}
