import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import 'hover_region.dart';

/// A panel defined by its border, not its fill.
///
/// Sits on the black canvas with a 1px hairline and no shadow. Elevation in
/// this design comes from the border alone — drop shadows on a pure-black page
/// are invisible at best and muddy at worst, and tinted card fills are the
/// glassmorphism look this replaced.
class HairlineCard extends StatelessWidget {
  const HairlineCard({
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.radius = 16,
    this.onTap,
    this.interactive = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  /// Brightens the border on hover. Set for anything clickable.
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    if (!interactive && onTap == null) return _build(context, false);
    return HoverRegion(onTap: onTap, builder: _build);
  }

  Widget _build(BuildContext context, bool hovered) {
    return AnimatedContainer(
      duration: AppMotion.hover,
      curve: AppMotion.ease,
      padding: padding,
      decoration: BoxDecoration(
        // A barely-there lift on hover, not a color change.
        color: hovered ? const Color(0x08FFFFFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: hovered ? AppColors.ashBright : AppColors.ashBorder,
        ),
      ),
      child: child,
    );
  }
}
