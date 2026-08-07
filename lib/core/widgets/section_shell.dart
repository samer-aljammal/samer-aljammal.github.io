import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';

/// Standard section wrapper: optional full-bleed background band, centred
/// content column capped at [Breakpoints.maxContentWidth], responsive gutters.
///
/// The [band] is what stops the page reading as one flat tone. Alternating the
/// obsidian canvas with a slate band gives the scroll a rhythm you feel rather
/// than read, and it costs nothing — no image, no gradient, no shadow.
class SectionShell extends StatelessWidget {
  const SectionShell({
    required this.child,
    this.topSpacing,
    this.bottomSpacing,
    this.band = false,
    super.key,
  });

  final Widget child;
  final double? topSpacing;
  final double? bottomSpacing;

  /// Fill the full width with the slate surface instead of the canvas.
  final bool band;

  @override
  Widget build(BuildContext context) {
    final double rhythm = context.sectionSpacing;

    final Widget content = Padding(
      padding: EdgeInsets.only(
        left: context.gutter,
        right: context.gutter,
        top: topSpacing ?? rhythm,
        bottom: bottomSpacing ?? rhythm,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );

    if (!band) return content;

    return DecoratedBox(
      // Eased into and out of the canvas at the edges rather than a hard cut,
      // so the band reads as light falling on the page.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.obsidian,
            AppColors.slateShadow,
            AppColors.slateShadow,
            AppColors.obsidian,
          ],
          stops: [0, 0.16, 0.84, 1],
        ),
      ),
      child: content,
    );
  }
}
