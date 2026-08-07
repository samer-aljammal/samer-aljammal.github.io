import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'hover_region.dart';

/// Text link with a rule that wipes in from the left on hover.
///
/// Left-anchored rather than fading in, so the motion runs with the reading
/// direction. Used for every inline action — source links, contact rows,
/// footer links — so the page has one link behaviour instead of several.
class UnderlineLink extends StatelessWidget {
  const UnderlineLink({
    required this.label,
    required this.onTap,
    this.icon,
    this.style,
    this.color = AppColors.bone,
    this.hoverColor = AppColors.bone,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final TextStyle? style;
  final Color color;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    final TextStyle base =
        style ?? AppTypography.sans(fontSize: 13, color: color);

    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: base.copyWith(color: hovered ? hoverColor : color),
              ),
              if (icon case final IconData icon) ...[
                const SizedBox(width: 7),
                AnimatedSlide(
                  offset: Offset(hovered ? 0.2 : 0, hovered ? -0.2 : 0),
                  duration: AppMotion.hover,
                  curve: AppMotion.ease,
                  child: Icon(
                    icon,
                    size: (base.fontSize ?? 13) + 1,
                    color: hovered ? hoverColor : color,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Scale-x from the left edge: cheaper than animating width, and it
          // cannot cause a layout pass on hover.
          AnimatedScale(
            scale: hovered ? 1 : 0,
            alignment: Alignment.centerLeft,
            duration: AppMotion.hover,
            curve: AppMotion.ease,
            child: Container(
              height: 1,
              width: (base.fontSize ?? 13) * label.length * 0.62,
              color: hoverColor,
            ),
          ),
        ],
      ),
    );
  }
}
