import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import 'hover_region.dart';

enum GhostButtonSize { regular, small }

/// The only button in the design: transparent fill, 1px border, white label.
///
/// Never filled, never colored. A saturated call-to-action button is the most
/// recognisable tell of a template, and on a black canvas a hairline outline
/// reads as more expensive than any fill would. Hover brightens the border and
/// the label — it does not glow, lift or scale.
class GhostButton extends StatelessWidget {
  const GhostButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.emphasis = false,
    this.size = GhostButtonSize.regular,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Inverts to a solid white chip. At most one per page — this is the single
  /// strongest action, and it earns its weight by being the only filled thing
  /// on the canvas.
  final bool emphasis;

  final GhostButtonSize size;

  @override
  Widget build(BuildContext context) {
    final bool small = size == GhostButtonSize.small;

    return HoverRegion(
      onTap: onPressed,
      builder: (BuildContext context, bool hovered) {
        final Color foreground = emphasis
            ? AppColors.obsidian
            : (hovered ? AppColors.bone : AppColors.bone);

        return AnimatedContainer(
          duration: AppMotion.hover,
          curve: AppMotion.ease,
          padding: EdgeInsets.symmetric(
            horizontal: small ? 14 : 20,
            vertical: small ? 9 : 14,
          ),
          decoration: BoxDecoration(
            color: emphasis
                ? (hovered ? AppColors.bone : AppColors.bone)
                : (hovered ? const Color(0x0DFFFFFF) : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: emphasis
                  ? Colors.transparent
                  : (hovered ? AppColors.ashBright : AppColors.ashBorder),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontSize: small ? 13 : 14,
                ),
              ),
              if (icon case final IconData icon) ...[
                SizedBox(width: small ? 7 : 9),
                AnimatedSlide(
                  offset: Offset(hovered ? 0.22 : 0, 0),
                  duration: AppMotion.hover,
                  curve: AppMotion.ease,
                  child: Icon(icon, size: small ? 13 : 15, color: foreground),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
